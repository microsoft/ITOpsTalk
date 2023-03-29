
param(

    [string]$ResourceGroupName = "Secret-Demo",
    [string]$vaultname = "SecretDemoVault"

)
Disable-AzContextAutosave -Scope Process

$VERSION = "1.0"
$currentTime = (Get-Date).ToUniversalTime()

Write-Output "Runbook started. Version: $VERSION at $currentTime"
Write-Output "---------------------------------------------------"

# Authenticate with your Automation Account
$connection = Get-AutomationConnection -Name AzureRunAsConnection
# Wrap authentication in retry logic for transient network failures
$logonAttempt = 0
while (!($connectionResult) -and ($logonAttempt -le 10)) {
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult = Connect-AzAccount `
        -ServicePrincipal `
        -Tenant $connection.TenantID `
        -ApplicationId $connection.ApplicationID `
        -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 30
}

$AzureContext = Get-AzSubscription -SubscriptionId $connection.SubscriptionID
$SubID = $AzureContext.id
Write-Output "Subscription ID: $SubID"
Write-Output "Resource Group: $ResourceGroupName"
Write-Output "VaultName: $vaultname"

# Get Secret from KeyVault
Register-SecretVault -Name AzKeyVault -ModuleName Az.KeyVault -VaultParameters @{ AZKVaultName = $vaultname; SubscriptionId = $SubID }
$secret = Get-Secret -Vault AzKeyVault -Name sysadmin
Write-Output "SecretValue :  $secret"
$Credential = New-Object -TypeName PSCredential -ArgumentList "sysadmin", $secret

# Get a list of all virtual machines in subscription
$VMList = Get-AzVM -ResourceGroupName $ResourceGroupName
foreach ($vm in $VMList) {
    Write-Output "Reseting password on $vm.name" 
    Set-AzVMAccessExtension -ResourceGroupName $ResourceGroupName -VMName $Vm.Name -Credential $Credential -typeHandlerVersion "2.0" -Name VMAccessAgent
}