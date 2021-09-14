  
######################################################################################################
# Script to restart "BesClient" and "besrelay" services on all corporate Relay Servers
# Create Date: 14 Sep 2021
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
      		Get-Service -Name "besrelay" | Restart-Service -Verbose
		}
		Write-Host "Services restarted on relay server:" $hosts
	}