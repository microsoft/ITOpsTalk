# Leveraging PowerShell SecretManagement to generalize a demo environment

*Published Apr 07 2021 11:57 PM*

I’ve been working with some colleagues on a shared demo environment, and one issue came up during a session with customers that highlighted a problem.  If any of us change the local admin password of the servers or redeploys the environment with a password of their own.  We no longer can access it without contacting the group and request the new password.

I started to look a way to regularly update the password from a location that is built specifically for storing passwords and other secrets. Namely, Azure Key Vault.

The SecretManagement module helps users manage secrets by providing a common set of cmdlets to interface with secrets across vaults. IT utilizes an extensible model where local and remote vaults (including Azure Key Vaults) can be registered and unregistered for use in accessing and retrieving secrets.

The module provides the following cmdlets for accessing secrets and managing SecretVaults:

* Get-Secret
* Get-SecretInfo
* Get-SecretVault
* Register-SecretVault
* Remove-Secret
* Set-Secret
* Set-SecretInfo
* Set-SecretVaultDefault
* Test-SecretVault
* Unregister-SecretVault

## The Solution

To address our issue, we took the following steps.

1. Created a key vault and created/stored a secret with a complex password. (because it’s in the demo resource group, we can all retrieve the secret when needed)
1. Deployed Azure Automation in our environment and created a Run as account to provide authentication for managing resources in Azure with the Azure cmdlets.  I had to assign the proper rights to the Run-As account in our Key Vault. To ensure good security, I restricted the automation account to Get and List for Secret Management Operation.
1. Created a new Runbook that would get the secret from Key vault using PowerShell **Microsoft.PowerShell.SecretManagement** module and using the Azure VMAccess extension would update the local admin password to the one retrieved from Key vault. (The sample code available [Here](Local-Admin-Password-set.ps1)). Of course, this is proof of concept at this point and needs to be worked on. However, it does open the door to other usage. This could be re-used and modified to run on a schedule to generate a new complex password and store it in Key Vault, then update all the servers in your environment with the new password on a regular basis.

The code in [Local-Admin-Password-set.ps1](Local-Admin-Password-set.ps1) required me to import some PowerShell Modules into our Automation environment.  The modules I imported from the gallery are:

* Az.Accounts
* Az.Compute
* AZ.KeyVault
* Microsoft.PowerShell.SecretManagement
* Microsoft.PowerShell.SecretStore

That's it!  a simple solution based on a new PowerShell module that provides us with loads of value.  Maybe it will be of value for you too.

Cheers!
