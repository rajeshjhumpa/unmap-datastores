#Script to run unmap on all the datastores in a virtual center

#environment variables
$username = $env:username
$pass = $env:password


#Import PowerCLI Module
Import-Module VMware.PowerCLI

#Reset session timeout
Set-PowerCLIConfiguration -Scope Session -WebOperationTimeoutSeconds -1 -InvalidCertificateAction Ignore -Confirm:$False
Foreach ( $server in $servers )
{
  #connect to the vcenter server
  Connect-VIServer -Server $server -User $username -Password $pass

  $datastores = Get-Datastore | where{$_.Type -eq 'VMFS'}
  Foreach ($datastore in $datastores)
      {
         $esx = $server
         $esxcli = Get-EsxCli -VMHost $esx -V2
         $unmapargs = $esxcli.storage.vmfs.unmap.CreateArgs()
         $unmapargs.volumelabel = $datastore
         $unmapargs.reclaimunit = "256"
    
         Write-Host 'Unmapping' $datastore.Name on $esx
         $esxcli.storage.vmfs.unmap.Invoke($unmapargs)       
       }
 
Write-Host " unmap operation completed on all datastores"
Write-Host " Disconnecting from VIServer"
Disconnect-VIServer -server $Server -Force -Confirm:$False
}
