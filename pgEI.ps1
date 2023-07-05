#export and import portgroups
$primary_vcenter = "Source_vCenter_FQDN_OR_IP"
$secondary_server = "Destination_vCenter_FQDN_OR_IP"
$Svswitch = "Source_DVswitch_Name"
$Dvswitch = "Destination_DVswitch_Name"
$Paath = "Path on your computer for example: d:\portgroup"

#get source vcenter credential
$Pcredential = Get-Credential
#get destination vcenter credential
$Scredential = Get-Credential

#connectng to both vcenters
Connect-VIServer -Server $primary_vcenter -Credential $Pcredential
Connect-VIServer -Server $secondary_server -Credential $Scredential

#export source vcenter portgroup save them in a directory
$pg = Get-VDPortgroup  -VDSwitch $Svswitch -server $primary_vcenter
foreach($p in $pg)
{
    Export-VDPortGroup -VDPortGroup $p -Destination $Paath\$p.zip
}          


$newpg =  Get-ChildItem $Paath 
foreach($pp in $newpg) 
{
    #Remove .zip in name of portgroup
    $newname = $pp -replace ".zip" 
    New-VDPortgroup -VDSwitch $Dvswitch -Name $newname -BackupPath $Paath\$pp -Server $secondary_server
}
