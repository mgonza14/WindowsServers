<#
.SYNOPSIS
    Gets Domain Controllers from the Domain Controllers list in ACU
.DESCRIPTION
    Gets a list of Domain Controllers from AD based on the Domain Controllers OU
.EXAMPLE
    PS C:\> Get-ADDomainControllerList.ps1
    Speciffy what domain controllers to see in the specificed domain based on the Get-ADDomain object of the current logged on user
.EXAMPLE
    PS C:\> Get-ADDomainControllerList.ps1 -domainname <domainname>
    Speciffy what domain controllers to see in the specificed domain based on the specified domain you entered e.g. fakedomain.local
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

[CmdletBinding()]
param (
    [string]$DomainName = ""
)

if (-not $domainname) {
    $DomainName = Get-ADDomain -Current LoggedonUser | select-object -ExpandProperty Forest
}

# splits the domain into 2 parts with the . as the delimiter. This is so get-adcomputer command works 
$chararray = $DomainName.Split(".")
$DCPart1 = $chararray[0]
$DCPart2 = $chararray[1]

# to see what is being passed
Write-Verbose $DomainName
Write-verbose $DCPart1
Write-verbose $DCPart2

# queries AD and extracts the server names
get-adcomputer -filter * -SearchBase "OU=Domain Controllers, DC=$DCPart1, DC=$DCPart2" | select-object -ExpandProperty name 