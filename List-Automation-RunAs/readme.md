# Finding Azure Automation accounts that use Run As 

Azure Automation Run As Accounts will retire on September 30, 2023 and will be replaced with Managed Identities. For more information visit [FAQ for migrating from Run As account to managed identities](https://learn.microsoft.com/azure/automation/automation-managed-identity-faq?WT,mc_id=modinfra-0000-socuff)

The scripts in this folder allow you to list any Azure Automation accounts that have Run As accounts configured, so you can migrate them.

Feel free to use this script - or suggest an improvement!

## What does the script do?

The kql script can be run as a query in the Azure Portal, via the Azure Resource Graph Explorer.

The PowerShell script can be run locally (with the included Connect-AzAccount command) or run in Azure Cloud Shell inside the Azure Portal.

Both scripts fetch a list of Azure Automation Accounts where the runAsAccount property is NOT set to blank (unconfigured)
