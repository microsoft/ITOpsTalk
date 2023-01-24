$key = "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds"
Set-ItemProperty -Path $key -Name ConsolePrompting -Value $true