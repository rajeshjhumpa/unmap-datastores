#Script to run unmap on all the datastores in a virtual center

#environment variables
$username = $env:username
$pass = $env:password
$server = $env:server


#Import PowerCLI Module
Import-Module VMware.PowerCLI

#Reset session timeout
Set-PowerCLIConfiguration -Scope Session -WebOperationTimeoutSeconds -1 -Confirm:$False

#connect to the vcenter server
Connect-VIServer -Server $server -User $username -Password $pass

#Get all the datastore clusters
$datastoreclusters = Get-datastoreclusters

Workflow Unmappingdatastores {

#Run unmap on all datastores
Foreach -parallel ( $datastorecluster in $datastoreclusters )
{
  $datastores = Get-Datastore -Location $datastorecluster.Name | where{$_.Type -eq 'VMFS'}
  Foreach -parallel ($datastore in $datastores)
  {
    $esx = Get-VMHost -Datastore $datastore | Get-Random -Count 1
    $esxcli = Get-EsxCli -VMHost $esx
    Write-Host 'Unmapping' $datastore.Name on $esx
    $esxcli = InlineScript {($using:esxcli).storage.vmfs.unmap($null, $datastore.Name, $null)}
  }
}
Write-Host " unmap operation completed on all datastores"
Write-Host " Disconnecting from VIServer"

Disconnect-VIServer -server $Server -Force -Confirm:$False
}
