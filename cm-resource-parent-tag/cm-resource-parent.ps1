$ResourceParent = "vm-s19-01"
$ParentID = Get-AzResource -Name $ResourceParent | Select-Object -ExpandProperty ResourceID
$RG = "SVM-01-RG"
$resourcelist = Get-AzResource -ResourceGroupName $RG 

foreach($item in $resourcelist){
    $tags = @{"cm-resource-parent"=$ParentID}
    Update-AzTag -ResourceId $item.ResourceId -Tag $tags -Operation Merge

}