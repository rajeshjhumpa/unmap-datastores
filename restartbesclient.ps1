######################################################################################################
# Script to restart "BesClient" service on all corporate virtual machines
# Create Date: 10 June 2021
# Original Authors : Prateek Siddhu
# Updated By : Prateek Siddhu
# Version : 1.0
######################################################################################################

$hosts   = $env:hosts.split()
Write-Host "List of Servers:" $hosts

$username	= $env:username
$SecurePass = $env:password
$password 	= ConvertTo-SecureString -String "$SecurePass" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

	foreach ($hosts in $hosts) {
		Write-Host "Connecting to Server:" $hosts
		Invoke-Command -ComputerName $hosts -Credential $credential -ScriptBlock {
			Get-Service -Name "BesClient" | Restart-Service -Verbose
		}
		Write-Host "Service restarted on server:" $hosts
	}
