<#
.SYNOPSIS
    This script will take a text file of server names updates DNS settings via WINRM port 5983.
.DESCRIPTION
    
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.NOTES
Version Modifications																			  
1.2 - Code set to input a text file and parse each line item									  
1.1 - Code set to take in an array string within the code										  
1.0 - Code set to take in an individual string as input									      																				
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
