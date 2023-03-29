using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.

$RG = "WiredCanuck"
$ZoneName = "Wiredcanuck.com"

$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$NewIP = $Request.Query.IP
if (-not $NewIP) {
    $IP = $Request.Body.IP
}

$RecordSet = Get-AzDnsRecordSet -ResourceGroupName $RG -ZoneName $ZoneName -Name $name -RecordType A

if (-not $RecordSet) {
    $RecordSet = New-AzDnsRecordSet -Name $name -RecordType A -ZoneName $ZoneName -ResourceGroupName $RG -Ttl 3600 -DnsRecords (New-AzDnsRecordConfig -IPv4Address $NewIP)
}
$OldIP = $recordset.Records.Ipv4Address

if ($NewIP -ne $OldIP) {
    $body = "DNS address $name.$ZoneName does not match. $NewIP will be created"
    $Records = @()
    $Records += New-AzDnsRecordConfig -IPv4Address $NewIP
    $RecordSet = New-AzDnsRecordSet -Name $name -RecordType A -ZoneName $ZoneName -ResourceGroupName $RG -Ttl 3600 -DnsRecords $Records -Confirm:$False -Overwrite
}
Else {
    $body = "Dynamic address ($NewIP) and DNS address ($OldIP) match.  No update needed"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})