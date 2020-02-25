#####################################

 Version .03

#####################################

## Get FQDN of server. Either via prompt or if you run the script on the server, you can use the 2nd option
$server = Read-Host -Prompt 'Input your server name in FQDN format'
#$server = $ServerFQDN = ([System.Net.Dns]::GetHostByName(($env:computerName))).Hostname

## Get Cert Thumbprint based on current naming of FQDN. This is how the VinRM certs are currently being renewed via Venafi
$certThumbPrint = (Get-ChildItem -Path cert:\LocalMachine\My | Where-Object {$_.FriendlyName -eq "WinRM"} | Sort-Object -Property NotAfter -Descending | Select-Object -first 1).Thumbprint

## WinRMCreate doesn't run well outside of CMD shell, so we have to use extra characters to make it run in powershell. Encapsulating command and extra characters in the variable $WinrmCreate
## https://www.admin-enclave.com/en/articles/skypeforbusiness/318-configure-https-for-windows-remote-management-winrm-on-windows-2012-r2.html
## https://stackoverflow.com/questions/24963890/executing-command-from-powershell

$WinrmCreate= 'winrm create winrm/config/Listener?Address=*+Transport=HTTPS `@`{Hostname=`"`'+$server+'`"`;CertificateThumbprint=`"`'+$certThumbPrint+'`"`}' 

## Show the current config
winrm e winrm/config/listener

## Need to delete the current config or you get an error in powershell when creating
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS

## since it's a cmd command, we have to run the variable inside the invoke-expression
invoke-expression $WinrmCreate

## Show the modified config
winrm e winrm/config/listener