# Connect to Azure
Connect-AzAccount

# Get all Azure Automation accounts
$automationAccounts = Get-AzResource -ResourceType "Microsoft.Automation/automationAccounts"

# Filter for Automation accounts with Run As Accounts
$automationAccounts = $automationAccounts | Where-Object { $_.Properties.RunAsAccount -ne $null }

# Display the results
foreach ($account in $automationAccounts) {
    Write-Host "Automation account: $($account.Name)"
    Write-Host "Resource group: $($account.ResourceGroupName)"
    Write-Host "Run As Account: $($account.Properties.RunAsAccount)"
    Write-Host "Location: $($account.Location)"
    Write-Host "--------------------------"
}
