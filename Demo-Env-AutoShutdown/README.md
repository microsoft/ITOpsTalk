# Welcome

To manage the costs and to keep track of the resources deployed in am Azure  subscription we've setup a process to shutdown VM based on tags.

We create a Automation Runbook that runs the process every night at 12:00am eastern time zone.  this document outlines the perticulars of our efforts

Please ensure that you tag your resources with the following tags

1. Category - is this resource for demo, personal or production purpose?
1. StaffID - person responsible for this resource
1. LifeCycle - persistent or non-persistent meaning can it be turned off during off hours
1. TimeZone - This Tag is for VMs (Virtual Machines) only. The “TimeZone” you are using the VM (Virtual Machines) in will dictate the auto-shutdown policy If NO tag is set the policy will default it to “Eastern Standard Time”
* i.e.: If you are in Brisbane, Australia by setting the “TimeZone” tag to “AUS Eastern Standard Time” the auto-shutdown process will be set for 11:59pm in THAT time zone.

Here is the list of time zones: (please cut and paste to avoid typos)

* AUS Central Standard Time
* AUS Eastern Standard Time
* Afghanistan Standard Time
* Alaskan Standard Time
* Aleutian Standard Time
* Altai Standard Time
* Arab Standard Time
* Arabian Standard Time
* Arabic Standard Time
* Argentina Standard Time
* Astrakhan Standard Time
* Atlantic Standard Time
* Aus Central W. Standard Time
* Azerbaijan Standard Time
* Azores Standard Time
* Bahia Standard Time
* Bangladesh Standard Time
* Belarus Standard Time
* Bougainville Standard Time
* Canada Central Standard Time
* Cape Verde Standard Time
* Caucasus Standard Time
* Cen. Australia Standard Time
* Central America Standard Time
* Central Asia Standard Time
* Central Brazilian Standard Time
* Central Europe Standard Time
* Central European Standard Time
* Central Pacific Standard Time
* Central Standard Time (Mexico)
* Central Standard Time
* Chatham Islands Standard Time
* China Standard Time
* Cuba Standard Time
* Dateline Standard Time
* E. Africa Standard Time
* E. Australia Standard Time
* E. Europe Standard Time
* E. South America Standard Time
* Easter Island Standard Time
* Eastern Standard Time (Mexico)
* Eastern Standard Time
* Egypt Standard Time
* Ekaterinburg Standard Time
* FLE Standard Time
* Fiji Standard Time
* GMT Standard Time
* GTB Standard Time
* Georgian Standard Time
* Greenland Standard Time
* Greenwich Standard Time
* Haiti Standard Time
* Hawaiian Standard Time
* India Standard Time
* Iran Standard Time
* Israel Standard Time
* Jordan Standard Time
* Kaliningrad Standard Time
* Korea Standard Time
* Libya Standard Time
* Line Islands Standard Time
* Lord Howe Standard Time
* Magadan Standard Time
* Magallanes Standard Time
* Marquesas Standard Time
* Mauritius Standard Time
* Middle East Standard Time
* Montevideo Standard Time
* Morocco Standard Time
* Mountain Standard Time (Mexico)
* Mountain Standard Time
* Myanmar Standard Time
* N. Central Asia Standard Time
* Namibia Standard Time
* Nepal Standard Time
* New Zealand Standard Time
* Newfoundland Standard Time
* Norfolk Standard Time
* North Asia East Standard Time
* North Asia Standard Time
* North Korea Standard Time
* Omsk Standard Time
* Pacific SA Standard Time
* Pacific Standard Time (Mexico)
* Pacific Standard Time
* Pakistan Standard Time
* Paraguay Standard Time
* Qyzylorda Standard Time
* Romance Standard Time
* Russia Time Zone 10
* Russia Time Zone 11
* Russia Time Zone 3
* Russian Standard Time
* SA Eastern Standard Time
* SA Pacific Standard Time
* SA Western Standard Time
* SE Asia Standard Time
* Saint Pierre Standard Time
* Sakhalin Standard Time
* Samoa Standard Time
* Sao Tome Standard Time
* Saratov Standard Time
* Singapore Standard Time
* South Africa Standard Time
* South Sudan Standard Time
* Sri Lanka Standard Time
* Sudan Standard Time
* Syria Standard Time
* Taipei Standard Time
* Tasmania Standard Time
* Tocantins Standard Time
* Tokyo Standard Time
* Tomsk Standard Time
* Tonga Standard Time
* Transbaikal Standard Time
* Turkey Standard Time
* Turks And Caicos Standard Time
* US Eastern Standard Time
* US Mountain Standard Time
* UTC+12
* UTC+13
* UTC
* UTC-02
* UTC-08
* UTC-09
* UTC-11
* Ulaanbaatar Standard Time
* Venezuela Standard Time
* Vladivostok Standard Time
* Volgograd Standard Time
* W. Australia Standard Time
* W. Central Africa Standard Time
* W. Europe Standard Time
* W. Mongolia Standard Time
* West Asia Standard Time
* West Bank Standard Time
* West Pacific Standard Time
* Yakutsk Standard Time
* Yukon Standard Time

## Auto-Shutdown

The Auto-Shutdown will be automatically set by an automation Runbook running nightly at 12:00am Eastern Standard Time.

## Runbook output from Script

VM Name = *VM_Name*
LifeCycle = *non-persistent*
Central America Standard Time
Building Auto-Shutdown properties
---------------------------------
---------------------------------

Name              : *VM_Name*
ResourceId        : */subscriptions/00000000-0000-0000-0000-000000000000/resourc
                    egroups/rg/providers/microsoft.devtestlab/schedu
                    les/shutdown-computevm-VM_Name*
ResourceName      : *shutdown-computevm-arcbox-client*
ResourceType      : microsoft.devtestlab/schedules
ResourceGroupName : *rg*
Location          : *centralus*
SubscriptionId    : 00000000-0000-0000-0000-000000000000
Tags              : {Project}
Properties        : @{status=Enabled; taskType=ComputeVmShutdownTask; 
                    dailyRecurrence=; timeZoneId=Central America Standard 
                    Time; notificationSettings=; 
                    createdDate=2022-07-19T16:20:44.6958634+00:00; targetResour
                    ceId=/subscriptions/00000000-0000-0000-0000-000000000000/re
                    sourceGroups/RG/providers/Microsoft.Compute/virt
                    ualMachines/VM_Name; provisioningState=Succeeded; 
                    uniqueIdentifier=00000000-0000-0000-0000-000000000000}