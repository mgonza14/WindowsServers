<#
.SYNOPSIS
    This script will take a text file of server names updates DNS settings via WINRM port 5983.
.DESCRIPTION
    
.EXAMPLE
    DNS_Get_DNS_Settings_Group.ps1
.NOTES
Future modifications
-add ability to state txt file of server names
-add param value for computer input
-add validate commands to make sure no wrong info is etnered
-change this script into a function 
.LINK
https://github.com/mgonza14/WindowsServers/blob/master/DNS_Get_DNS_Settings_Group.ps1								      																				
#>

ForEach ($RemoteComputers in Get-Content DNS_Get_DNS_Settings_Group.txt) {
    $computer = $RemoteComputers
	# 1. List Computer Name where DNS is being Changed
	Write-Host "Computer Name: " $Computer  -ForegroundColor Green
    
	Invoke-Command -ComputerName $Computer -ScriptBlock { $Adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.DHCPEnabled -ne 'True' -and $_.DNSServerSearchOrder -ne $null}
		Write-Host "After: " -ForegroundColor Green
        $Adapters | ForEach-Object {$_.DNSServerSearchOrder}
    }
}
