#Welcome to the "Deploy AKS for gMSA validation" PowerShell script. 
#Use the instructions below to deploy a new Azure environment to try out the gMSA on AKS feature.
#If you haven't already, please install the Azure PowerShell module before using the commands below.

#You will need to login to Azure to deploy the resources.
#Login and select subscription
$Az_Sub = Read-Host -Prompt 'Please provide the Azure subscription ID to be used'
Connect-AzAccount -DeviceCode -Subscription $Az_Sub
#az login --use-device-code
#az account set --subscription $Az_Sub

#Create a Resource Group on Azure on which the resources will be deployed to
$RG_Name = Read-Host -Prompt "Please provide the Resource Group Name"
$RG_Location = Read-Host -Prompt "Please provide the Resource Group Loation"
New-AzResourceGroup -Name $RG_Name -Location $RG_Location

#Creates Azure vNet
$vNet_Name = Read-Host -Prompt "Please provide the vNet Name"
$vnet = @{
    Name = $vNet_Name
    ResourceGroupName = $RG_Name
    Location = $RG_Location
    AddressPrefix = '10.0.0.0/16'    
}
$virtualNetwork = New-AzVirtualNetwork @vnet

#Adds a Subnet configuration under the Azure vNet
$Subnet_Name = Read-Host 'Please provide the name of the Subnet to be created under the Azure vNet. This subnet will be used by Windows nodes on AKS as well as your DC'
$subnet = @{
    Name = $Subnet_Name
    VirtualNetwork = $virtualNetwork
    AddressPrefix = '10.0.0.0/16'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet

#Validate the vNet and subnet were created sucessfully
Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $virtualNetwork

#Associate the subnet to the virtual network
$virtualNetwork | Set-AzVirtualNetwork

#Creates AKS Cluster using the vNet created previously
#Currently, the AzAks PS module does not support creating a new cluster with Managed Identity. For this command only, we will use the AzCLI.
$AKSCluster_Name = Read-Host -Prompt 'Please provide the name for the AKS cluster'
$Username = Read-Host -Prompt 'Please create a username for the administrator credentials on your Windows Server nodes'
$Password = Read-Host -Prompt 'Please create a password for the administrator credentials on your Windows Server nodes' -AsSecureString
$vnetinfo = Get-AzVirtualNetwork -Name $vNet_Name -ResourceGroupName $RG_Name
$subnetid = $vnetinfo.Subnets[0].Id
New-AzAksCluster -ResourceGroupName $RG_Name -Name $AKSCluster_Name -NodeCount 2 -NetworkPlugin azure -NodeVnetSubnetID $subnetid -ServiceCidr '10.240.0.0/16' -DnsServiceIP '10.240.0.10' -NodeVmSetType VirtualMachineScaleSets -WindowsProfileAdminUserName $Username -WindowsProfileAdminUserPassword $Password -GenerateSshKey -EnableManagedIdentity
#az aks create --resource-group $RG_Name --name $AKSCluster_Name --node-count 2 --network-plugin azure --vnet-subnet-id $subnetid --service-cidr '10.240.0.0/16' --dns-service-ip '10.240.0.10' --vm-set-type VirtualMachineScaleSets --windows-admin-username $Username --windows-admin-password $Password --enable-managed-identity

#Creates new pool for Windows nodes
$AKSPool_Name = Read-Host -Prompt 'Please provide the name of the node pool that will host your Windows nodes (lowercase only, limited to 6 characters)'
New-AzAksNodePool -ResourceGroupName $RG_Name -ClusterName $AKSCluster_Name -Name $AKSPool_Name -VmSetType VirtualMachineScaleSets -OsType Windows -Count 1

#Creates new VM on the same vNet as AKS cluster
$VM_Name = Read-Host -Prompt 'Please provide the name of the VM that will be used later as a Domain Controller'
Write-Host 'Please provide the credentials to be used on the Azure VM'
$cred = Get-Credential
New-AzVM -ResourceGroupName $RG_Name -Location $RG_Location -Name $VM_Name -VirtualNetworkName $vNet_Name -SubnetName $Subnet_Name -Credential $cred -Image Win2019Datacenter -Size 'Standard_D2_v3' -PublicIpAddressName 'gMSADCPublicIP' -OpenPorts 3389

#At this point, the configuration on Azure is complete. Now you need to connect to the VM you just created via RDP and run the below commands in it.
Write-Host 'Your Azure environment is now setup. Please continue from inside the VM that was just deployed'