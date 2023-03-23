#### READ THIS: The following commands are supposed to be run on the Azure VM you just created ####

#Deploy ADDS on your Azure VM and promote it to a Domain Controller
Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
Write-Host 'Warning: Your VM will restart after this operation. Please save any In Progress work.'
$SafeModeAdministratorPassword = Read-Host -Prompt "DSRM Password" -AsSecureString
$Domain_DNSName = Read-Host -Prompt 'Please provide the DNS name for the new forest'
$Netbios = Read-Host -Prompt 'Please provide the Netbios name for the domain'
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName $Domain_DNSName -DomainNetbiosName $Netbios -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SkipPreChecks -SafeModeAdministratorPassword $SafeModeAdministratorPassword
