<#
.SYNOPSIS
    Connects to a Domain Controller and gets subnets not in AD Sites and Services
.DESCRIPTION
    Connects via SMB to a DC C:\windows\debug\netlogon.log, parses the data, and outputs a network subnet in the file.
.EXAMPLE
    PS C:\> Get-ADSitesMissingSubnets.ps1 -computername <computername>
    Conencts to <computername> via SMB
.EXAMPLE
    PS C:\> Get-ADSitesMissingSubnets.ps1 -computername <computername> | out-file c:\temp\ipaddr.txt
    Outputs a file of the output
.PARAMETER Computername
    String variable that inputs a computername(s)
.PARAMETER Regex
    Default value is "\b\d{1,3}\.\d{1,3}\.\d{1,3}\b" which gets the first 3 octects of the IP address
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, 
                ValueFromPipelineByPropertyName=$true,
                ValueFromPipeline=$true)]
    [String[]]$computername,
    [String]$regex = "\b\d{1,3}\.\d{1,3}\.\d{1,3}\b"
) #param

$output = foreach ($computer in $computername) {
    if (Test-path -Path \\$computer\c$\windows\debug\netlogon.log) {
        get-content -Path "\\$computer\c$\windows\debug\netlogon.log" | 
        select-string -Pattern $regex |  
        ForEach-Object { $_.Matches } | 
        ForEach-Object { $_.Value } | 
        Sort-Object -unique |                   #Sorts the single servers output into unique values
        ForEach-Object { $_ + '.0/24' }    
    } #if
    else {
        Write-Output "no file exist"
    } #else
} #Foreach

#Sorts the output from extra servers into unique values
$output  | Sort-Object -unique



