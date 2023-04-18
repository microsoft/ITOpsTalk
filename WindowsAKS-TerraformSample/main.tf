terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = "bd0b675c-02c7-49b2-8e49-ae963925fa6c"
  tenant_id         = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  client_id         = "00135f92-f257-46d2-b093-367daa974688"
  client_secret     = "NUX8Q~aFsz1Zn~gqyNi8ocOw65hEYCRPBFRkKdsB"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "testvnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.1.1.0/24"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "ContosoCluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix = "contosocluster"

  default_node_pool {
    name           = "lin"
    node_count     = var.node_count_linux
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = element(tolist(azurerm_virtual_network.vnet.subnet),0).id
  }

  windows_profile {
    admin_username = "Microsoft"
    admin_password = "M1cr0s0ft@2023"
  }
  
  network_profile {
    network_plugin = "azure"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "win" {
  name                  = "wspool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D4s_v3"
  node_count            = var.node_count_windows
  os_type               = "Windows"
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}