param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $deleteResources,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $subscriptionId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $serviceObjectsRgName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $computeObjectsRgName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $storageObjectsRgName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $networkObjectsRgName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $monitoringObjectsRgName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $azureCloudEnvironment,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $managementVmName
)
        
try 
{
    ##############################################################
    #  Delete management VM
    ##############################################################
    if($deleteResources -eq 'true')
    {
        Select-AzSubscription -SubscriptionId $subscriptionId
        Remove-AzVM -Name $managementVmName -ResourceGroupName $serviceObjectsRgName -Force
    }
}
catch 
{
    Write-Log -Message $_ -Type 'ERROR'
    throw
}