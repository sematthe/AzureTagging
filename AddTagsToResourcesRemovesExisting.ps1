# Script to apply tags to existing resources within a resource group 
# that you have an Azure Assignment configured to apply tags to, will remove existing tags not defined in policy

$resources = Get-AzureRmResource -ResourceGroupName 'Hub'

foreach ($r in $resources) {
    try {
        Set-AzureRmResource -Tags ($a = if ($r.Tags -eq $NULL) { @{} } else {$r.Tags}) -ResourceId $r.ResourceId -Force -UsePatchSemantics
    }
    catch {
        Write-Host $r.ResourceId + "can't be updated"
    }
}
