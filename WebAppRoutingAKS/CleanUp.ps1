#!/usr/bin/env pwsh

#Clean up your environment after you validated Web Application Routing with Windows containers
$RG_Name = Read-Host -Prompt "Please provide the Resource Group Name you want to delete"
Remove-AzResourceGroup -Name $RG_Name -Force | Out-Null
Write-Host "$RG_Name has been deleted"
#There might be other resource groups created along with the resources above (Such as Network Watcher). Please double check your subscription for remaining resources.
