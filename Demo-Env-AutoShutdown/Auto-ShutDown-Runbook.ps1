<#
    .DESCRIPTION
        Set to azure auto-shutdown at 11:59pm in the timezone specified in the TimeZone tag for each VM.

    .NOTES
        AUTHOR: Pierre Roman
        LASTEDIT: July 18, 2022
#>

try {
    Connect-AzAccount -Identity | Out-Null
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

#Get all ARM resources from all resource groups
$subscription = Get-AzSubscription
$SubscriptionId = $subscription.Id
$ResourceGroups = Get-AzResourceGroup

foreach ($ResourceGroup in $ResourceGroups)
{    
    $vms = Get-AzVM -ResourceGroupName $ResourceGroup.ResourceGroupName
    foreach ($vm in $vms)
    {
        $VMName = $vm.Name
        $Tags = (Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName -Name $vm.Name).Tags
        foreach ($Tag in $Tags)
        {
            Write-Output ('VM Name = '+ $VMName)
            Write-Output ('LifeCycle = '+ $Tag.LifeCycle)
            
            if (!$Tag.TimeZone)
                {
                    $TimeZone = 'Eastern Time Zone'
                }
                else
                {
                    $TimeZone = $Tag.TimeZone.Trim()
                }
            
                Write-Output ($TimeZone)

            $Location = $vm.Location
            $RGName = $ResourceGroup.ResourceGroupName
            $VMId = $vm.Id

            if ($Tag.LifeCycle.ToLower() -eq 'non-persistent')
            {
                Write-Output ('Building Auto-Shutdown properties')
				Write-Output ('---------------------------------')
				$ScheduledShutdownResourceId = '/subscriptions/'+$SubscriptionId+'/resourceGroups/'+$RGName+'/providers/microsoft.devtestlab/schedules/shutdown-computevm-'+$VMName
                $Properties = @{}
                $Properties.Add('status', 'Enabled')
                $Properties.Add('taskType', 'ComputeVmShutdownTask')
                $Properties.Add('dailyRecurrence', @{'time' = 1159 })
                $Properties.Add('timeZoneId', "$TimeZone")
                $Properties.Add('notificationSettings', @{status = 'Disabled'; timeInMinutes = 15 })
                $Properties.Add('targetResourceId', $VMId)

                Write-Output ('---------------------------------')
                Try
				{
					New-AzResource -Location $Location -ResourceId $ScheduledShutdownResourceId  -Properties $Properties -Force 
				}
				Catch
				{
					"Error"
				}
            }
        }
    }
}
