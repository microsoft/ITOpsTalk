# Project

Azure DNS doesn't currently support zone transfers so I could not setup a zone transfer from my own DNS server. DNS zones can be imported into Azure DNS by using the Azure CLI. DNS records are managed via the Azure DNS management portal, REST API, SDK, PowerShell cmdlets, or the CLI tool.

I used a client/server approach that will schedule a job on a Local Linux server to get the external IP provided by the ISP and send it to an Azure Function via a webhook and let the function update the cname DNS record in ab Azure DNS zone.

We can secure the webhook with a function key and assign a managed identity to the function, so it only has rights to update the zone records but not change any of the other configuration and security.

## Linux Server setup

I installed PowerShell Core on a Linux running instance internally. Used a simple script [Get-PublicIP.ps1](Get-PublicIP.ps1) that runs every hour to get the external IP address and send it to the Azure Function via a webhook.

## Azure Function setup

I created a new Azure Function App and a new Function. I used the HTTP trigger template and added a new function key to secure the webhook. I also added a managed identity to the function app and assigned it the DNS Zone Contributor role.  The PowerShell code [homeDNSUpdate.ps1](homeDNSUpdate.ps1) is used to update the DNS record.
