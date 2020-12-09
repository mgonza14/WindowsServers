<#
.SYNOPSIS
    DNS change script
.DESCRIPTION
    This script will take a text file of server names updates DNS settings via WINRM port 5983.       
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.NOTES
##	Version Modifications																			  
##	- 1.2 - Code set to input a text file and parse each line item									  
##	- 1.1 - Code set to take in an array string within the code										  
##	- 1.0 - Code set to take in an individual string as input									      																				
                                                                                                     
#######################################################################################################
#>

ForEach ($RemoteComputers in Get-Content servers.txt) {
    $computer = $RemoteComputers
	# 1. List Computer Name where DNS is being Changed
	Write-Host "Computer Name: " $Computer  -ForegroundColor Green
    
	Invoke-Command -ComputerName $Computer -ScriptBlock {
        #2. sets new dns servers. Change IP ADDR to the IP address of the DNS servers
		$NewDnsServerSearchOrder = "IP ADDR, IP ADDR"
        
		#3. searches the network interfaces for static settings
		$Adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.DHCPEnabled -ne 'True' -and $_.DNSServerSearchOrder -ne $null}
        
        #4.  Show DNS settings on server before change
        Write-Host "Before: " -ForegroundColor Green
        $Adapters | ForEach-Object {$_.DNSServerSearchOrder}
 
        #5. Update DNS servers
        $Adapters | ForEach-Object {$_.SetDNSServerSearchOrder($NewDnsServerSearchOrder)} | Out-Null
 
        #6.  Show DNS servers on server after update
        $Adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.DHCPEnabled -ne 'True' -and $_.DNSServerSearchOrder -ne $null}
		Write-Host "After: " -ForegroundColor Green
        $Adapters | ForEach-Object {$_.DNSServerSearchOrder}
    }
}
