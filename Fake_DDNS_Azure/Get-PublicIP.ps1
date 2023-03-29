Function Get-ExternalIP {
    $jsonContent = Invoke-WebRequest -UseBasicParsing -Uri "http://ipinfo.io/json" | ConvertFrom-Json

    $pattern = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"

    If ($jsonContent.ip -match $pattern)
    {
        return $jsonContent.ip
    }
    Else
    {
        Write-Output "False"
        Return $false
    }
}

$logfilepath= "/home/username/pwsh.log"
Start-Transcript -Path $logfilepath

$datestamp = Get-Date
write-host $datestamp

# get the current DNS record

## (Using Dig since Resolve-DnsName in the DnsClient module as not yet been ported to PowerShell Core)
$EI = dig home.wiredcanuck.com +short

## (Using Resolve-DnsName if you are running this on a Windows Server)
## $EI = Resolve-DnsName home.wiredcanuck.com | Select-Object -ExpandProperty IPAddress

Write-host $EI.IPAddress

$IP = Get-ExternalIP

if ($IP -ne $EI)
{
    $WebHook = https://homednsupdate.azurewebsites.net/api/UpdateDNSRecord

    # the code below id the Function Key
    $code = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    $name = "home"

    write-host "External IP is $IP"

    $URL = $WebHook+"?code="+$code+"&name="+$name+"&ip="+$IP

    write-host "calling WebHook"

    $response = Invoke-WebRequest -UseBasicParsing $URL -Method POST

    Write-host $response

}
Else
{
    write-host "Current IP ($IP) is the same as the IP in the DNS record ($EI).  no update needed"
}