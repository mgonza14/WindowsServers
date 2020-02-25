$cred = get-credential

## If you manually put in the creds in the script
<#
$Username = 'labuser'
$Password = 'labuser'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass
#>

ForEach ($RemoteComputers in Get-Content SQL_Server_SVC_Account_Add_Group-ACU_Servers.txt) 
{
    $server = $RemoteComputers
    
	## Script block that holds the commands we'll run remotely
	$SB = {

		$certThumbprint = (Get-ChildItem -Path cert:\LocalMachine\My | Where-Object {$_.FriendlyName -eq "WinServices"} | Sort-Object -Property NotAfter -Descending | Select-Object -first 1).Thumbprint
		Write-Output $certThumbprint

		
		$keyName=(((Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Thumbprint -like $CertThumbprint}).PrivateKey).CspKeyContainerInfo).UniqueKeyContainerName
		$keyPath = "C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\"
		$fullPath=$keyPath+$keyName

		## Not needed but used to track what the full path was for troubleshooting
		Write-Output $FullPath

		$acl=Get-Acl -Path $fullPath
		$permission="ACU\svcentdb","Read","Allow"
		$accessRule=new-object System.Security.AccessControl.FileSystemAccessRule $permission
		$acl.AddAccessRule($accessRule)
		Set-Acl $fullPath $acl

		$acl=Get-Acl -Path $fullPath
		$permission="ACU\svcuatdb","Read","Allow"
		$accessRule=new-object System.Security.AccessControl.FileSystemAccessRule $permission
		$acl.AddAccessRule($accessRule)
		Set-Acl $fullPath $acl

    }

    Invoke-Command -ComputerName $server -Credential $cred -ScriptBlock $SB
}
