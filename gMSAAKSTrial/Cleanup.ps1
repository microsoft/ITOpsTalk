#Clean up environment after you validated your gMSA on AKS application
$RG_Name = Read-Host -Prompt "Please provide the Resource Group Name you want to delete"
Remove-AzResourceGroup -Name $RG_Name -Force
#There might be other resource groups created along with the resources above (Such as Network Watcher). Please double check your subscription for remaining resources.