terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.55.0"
    }
  }
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }
}

#Creates Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

#Creates Azure User Assigned Managed Identity
resource "azurerm_user_assigned_identity" "managed_identity" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = "gmsami"
}

#Creates Azure Key Vault
resource "azurerm_key_vault" "akv" {
  name                        = "gmsatestviniap"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = false
  sku_name = "standard"
}

#Assign reader role to MI on Azure Key Vault
resource "azurerm_role_assignment" "mi_akv_reader" {
  scope                = azurerm_key_vault.akv.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
}

#Define AKV access policy for MI
resource "azurerm_key_vault_access_policy" "akvpolicy" {
  key_vault_id = azurerm_key_vault.akv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.managed_identity.principal_id

  secret_permissions = [
    "Get"
  ]
}

#Assign reader role to Terraform session on Azure Key Vault
resource "azurerm_role_assignment" "tf_akv_reader" {
  scope                = azurerm_key_vault.akv.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.current.client_id
}

#Define AKV access for terraform session
resource "azurerm_key_vault_access_policy" "tfpolicy" {
  key_vault_id = azurerm_key_vault.akv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]
}

#Creates the secret on Azure Key Vault (careful: this is the standard user on your AD)
resource "azurerm_key_vault_secret" "gmsa_secret" {
  name         = "gmsasecret"
  value        = "${var.netbios_name}\\${var.gmsa_username}:${var.gmsa_userpassword}"
  key_vault_id = azurerm_key_vault.akv.id
}

#Creates Azure Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "gmsavnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16","10.1.0.0/26"]
}

#Creates the gMSA Subnet - both pods and Domain Controller will use this subnet
resource "azurerm_subnet" "gmsasubnet" {
  name                 = "gmsasubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/16"]
}

#Optional: Creates the Azure Bastion vNEt for RDP into DC01
resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/26"]
}

#Creates a vNIC for the DC VM - remove this if you have an existin DC
resource "azurerm_network_interface" "dc01_nic" {
  name                = "dc01_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "dc01_nic"
    subnet_id                     = azurerm_subnet.gmsasubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Creates the DC VM - remove this if you have an existing VM
#You need to connect to this VM and finish the Active Directory configuration
resource "azurerm_windows_virtual_machine" "dc01" {
  name                = "DC01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D4s_v3"
  admin_username      = var.win_username
  admin_password      = var.win_userpass
  network_interface_ids = [
    azurerm_network_interface.dc01_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

#Install Active Directory on the DC01 VM
resource "azurerm_virtual_machine_extension" "install_ad" {
  name                 = "install_ad"
#  resource_group_name  = azurerm_resource_group.main.name
  virtual_machine_id   = azurerm_windows_virtual_machine.dc01.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {    
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.ADDS.rendered)}')) | Out-File -filepath ADDS.ps1\" && powershell -ExecutionPolicy Unrestricted -File ADDS.ps1 -Domain_DNSName ${data.template_file.ADDS.vars.Domain_DNSName} -Domain_NETBIOSName ${data.template_file.ADDS.vars.Domain_NETBIOSName} -SafeModeAdministratorPassword ${data.template_file.ADDS.vars.SafeModeAdministratorPassword}"
  }
  SETTINGS
}

#Variable input for the ADDS.ps1 script
data "template_file" "ADDS" {
    template = "${file("ADDS.ps1")}"
    vars = {
        Domain_DNSName          = "${var.Domain_DNSName}"
        Domain_NETBIOSName      = "${var.netbios_name}"
        SafeModeAdministratorPassword = "${var.SafeModeAdministratorPassword}"
  }
} 

#Creates AKS cluster with Windows profile and gMSA enabled, and uses existing vNet
#This is dependable on DC01 VM as we need to set up the DNS primary IP for the Windows nodes
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "ContosoCluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix = "contosocluster"

  default_node_pool {
    name           = "lin"
    node_count     = var.node_count_linux
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.gmsasubnet.id
  }

  windows_profile {
    admin_username = var.win_username
    admin_password = var.win_userpass
    gmsa {
      dns_server = "10.0.0.4"
      root_domain = var.Domain_DNSName
    }
  }
  
  network_profile {
    network_plugin = "azure"
    service_cidr = "10.240.0.0/16"
    dns_service_ip = "10.240.0.10"
  }

  identity {
    type         = "SystemAssigned"
  }
  depends_on = [ 
    azurerm_windows_virtual_machine.dc01
   ]
}

#Creates Windows node pool on AKS cluster
resource "azurerm_kubernetes_cluster_node_pool" "win" {
  name                  = "wspool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D4s_v3"
  node_count            = var.node_count_windows
  os_type               = "Windows"
  depends_on = [ 
    azurerm_virtual_machine_extension.install_ad
   ]
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

#Assigns the User assigned Managed Identity to the Windows node pool
resource "null_resource" "identity_assign" {
  provisioner "local-exec" {
    command = "az vmss identity assign -g MC_${azurerm_resource_group.rg.name}_${azurerm_kubernetes_cluster.aks.name}_${azurerm_resource_group.rg.location}  -n aks${azurerm_kubernetes_cluster_node_pool.win.name} --identities /subscriptions/${data.azurerm_subscription.current.subscription_id}/resourcegroups/${azurerm_resource_group.rg.name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${azurerm_user_assigned_identity.managed_identity.name}"
  }
  depends_on = [ 
    azurerm_kubernetes_cluster_node_pool.win
   ]
}

#Update the VMSS instances
resource "null_resource" "vmss_update" {
  provisioner "local-exec" {
    command = "az vmss update-instances -g MC_${azurerm_resource_group.rg.name}_${azurerm_kubernetes_cluster.aks.name}_${azurerm_resource_group.rg.location}  -n aks${azurerm_kubernetes_cluster_node_pool.win.name} --instance-ids *"
  }
  depends_on = [ 
    null_resource.identity_assign
   ]
}

#Optional: Creates a public IP address for the Azure Bastion host
resource "azurerm_public_ip" "bastion_ip" {
  name                = "bastionip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Optional: Creates a Bastion Host to connect to the DC VM via RDP
resource "azurerm_bastion_host" "gmsa_dc_bastion" {
  name                = "gmsabastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}