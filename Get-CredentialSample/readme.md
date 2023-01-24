# Get-Credential with Windows Containers

**Note**: This sample is part of the blog post [How to use Get-Credential with Windows containers](https://techcommunity.microsoft.com/t5/itops-talk-blog/how-to-use-get-credential-with-windows-containers/ba-p/3723006)

By default, the Get-Credential PowerShell cmdlet doesn't work on Windows containers. This is because the default behavior of the command is to launch a pop-up on which the username and password can be entered by the user. Since Windows containers don't provide an UI, the command hangs indefinitely.

The [Get-CredentialSample.ps1](Get-CredentialSample.ps1) file on this folder contains a script for changing the default behavior of the command to get username and password from the console session. Feel free to use this script - or suggest an improvement!

## What the script does?

The script changes the PowerShell policy to accept credential input from the console session. The next time you use the Get-Credential cmdlet, it will ask for the username and password directly on the console session.
