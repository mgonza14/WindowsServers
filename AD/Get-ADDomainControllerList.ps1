
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

Write-Information -tag information "Check to see if module is installed"
function Get-InstalledModules ($modulename) {
    if (-not (Get-Module -ListAvailable -Name $modulename)) {
        Write-Error "ActiveDirectory Module doesn't exists. Terminating script" -ea stop
    }# if
}# function

write-information -tag information "running function" 
Get-InstalledModules ActiveDirectory

write-Information -tag information "check to see if we can get domain information"
try {
    if (-not $domainname) {
        $DomainName = Get-ADDomain -Current LoggedonUser | select-object -ExpandProperty Forest
    }# if 
}
catch {
    write-error "Error in getting Domain Name" -ea stop
}  

Write-Information -tag variables "Domain Name is $domainname"

# splits the domain into 2 parts with the . as the delimiter. This is so get-adcomputer command works 
$chararray = $DomainName.Split(".")

Write-Information -tag information "separating array into seperate variables to convert to string. Get-ADComputer -searchbase won't work with array objects"
$DCPart1 = $chararray[0]
$DCPart2 = $chararray[1]

# to see what is being passed
Write-Information $DomainName -tag variables
Write-Information $DCPart1 -tag variables
Write-Information $DCPart2 -tag variables

# queries AD and extracts the server names
get-adcomputer -filter * -SearchBase "OU=Domain Controllers, DC=$DCPart1, DC=$DCPart2" | select-object -ExpandProperty name 