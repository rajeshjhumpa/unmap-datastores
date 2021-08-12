######################################################################################################
# Script to Start virtual machines located in Azure
# Create Date: 31 July 2021
# Original Authors : Prateek Siddhu
# Updated By : Prateek Siddhu
# Version : 1.0
######################################################################################################

$vms = $env:vms.split()

$subscription 	= $env:subscriptionname
$client_id 		= $env:AZURE_CLIENT_ID
$tenant_id		= $env:AZURE_TENANT_ID
$client_secret	= $env:AZURE_CLIENT_SECRET

$secpasswd = ConvertTo-SecureString $CLIENT_SECRET -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($CLIENT_ID, $secpasswd)
Add-AzurermAccount -ServicePrincipal -Tenant $TENANT_ID -Credential $mycreds 

Set-AzurermContext -Subscription $subscription

ForEach ($vms in $vms) {

$vm = Get-AzureRMResource -ResourceName $vms -ResourceType Microsoft.Compute/virtualMachines
Start-AzureRMVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName
}

