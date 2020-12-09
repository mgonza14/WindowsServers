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

#>

#### Resrved fpr future reference
# function Get-DNSCLientDNSServerList_Single1 {
#     param (
#         [parameter(Mandatory=$true)]
#         [String[]]$computers
#     )
# }
$computers = 'hqverds101'

ForEach ($computer in $computers) {
  		  
    Invoke-Command -ComputerName $Computer -ScriptBlock { 
        # $Adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.DHCPEnabled -ne 'True' -and $_.DNSServerSearchOrder -ne $null} 
        Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.DHCPEnabled -ne 'True' -and $_.DNSServerSearchOrder -ne $null} #| gm #Select-Object -Property $_.DNSServerSearchOrder
        # Write-Host "This is in the variable $Adapters"
        # $Adapters | ForEach-Object {$_.DNSServerSearchOrder}
        
    } #Invoke-Command
} #ForEach
# } #function