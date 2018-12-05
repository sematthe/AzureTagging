Connect-AzureRmAccount

Select-AzureRmSubscription -SubscriptionId "Primary Microsoft Azure Internal Consumption"

Code Snippet that adds tags to the resources in a RG: 
# Tags to Append or Update for all resources in a resource group
$tagsToAdd = @{
    costCenter  = '56789'
    environment = 'development' 
    systemRole  = 'database'
    elemental = 'carbon'
}
# List of resoure groups to update
$resourceGroupList = @("spoke-a", "hub")
 
foreach ($rgName in $resourceGroupList) {
    Write-Output "Processing Resource Group: $rgName"
    $resourceGroup = Get-AzureRmResource -ResourceGroupName $rgName
    $tmpTags = @{} 
    foreach ($resource in $resourceGroup){
        Write-Output "   Resource Name: " + $resource.Name
        Write-Output "   Resource Type: " + $resource.Type
        $tmpTags = $resource.Tags
        if ($tmpTags -eq $null) {
            Write-Output "   No tags currently assigned to: " + $resource.Name
            Write-Output "   Assigning default tags to: " + $resource.Name
            $tmpTags = $tagsToAdd.Clone()   
        } else {
            Write-Output "   Updating tags currently assigned to: " + $resource.Name
            foreach ($key in $tagsToAdd.Keys) {
                if ($tmpTags.ContainsKey($key)) {
                    $tmpTags[$key] = $tagsToAdd[$key]
                } else {
                    $tmpTags.Add($key,$tagsToAdd[$key])
                }
            }
        }
        $resource | Set-AzureRmResource -Tag $tmpTags -Force
        $tmpTags.clear()
    }
}