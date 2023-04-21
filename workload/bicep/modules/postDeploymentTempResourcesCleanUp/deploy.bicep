// ========== //
// Parameters //
// ========== //

@description('Location where to deploy compute services.')
param location string

@description('Location for the AVD agent installation package.')
param scriptUri string

@description('Azure cloud.')
param azureCloudName string

@description('Virtual machine name to deploy the DSC extension to.')
param managementVmName string

@description('Tags to be applied to resources')
param tags object

@description('Flag to enable or not temp resource deletion')
param deleteResources bool

@description('Script file name.')
param scriptFile string

@description('Subscription ID.')
param subscriptionId string

@description('Service objects resource group name.')
param serviceObjectsRgName string

@description('Compute objects resource group name.')
param computeObjectsRgName string

@description('Storage objects resource group name.')
param storageObjectsRgName string

@description('Network objects resource group name.')
param networkObjectsRgName string

@description('Monitoring objects resource group name.')
param monitoringObjectsRgName string

@description('Do not modify, used to set unique value for resource deployment.')
param time string = utcNow()

// =========== //
// Variable declaration //
// =========== //
var varPostDeploymentTempResuorcesCleanUpScriptArgs = '-deleteResources ${deleteResources} -subscriptionId ${subscriptionId} -serviceObjectsRgName ${serviceObjectsRgName} -computeObjectsRgName ${computeObjectsRgName} -storageObjectsRgName ${storageObjectsRgName} -networkObjectsRgName ${networkObjectsRgName} -monitoringObjectsRgName ${monitoringObjectsRgName} -azureCloudEnvironment ${azureCloudName} -managmentVmName ${managementVmName} -Verbose'
//-DisaStigCompliance ${DisaStigCompliance}  -FSLogix ${Fslogix} -FslogixSolution ${FslogixSolution} -HostPoolName ${HostPoolName} -HostPoolRegistrationToken ${reference(resourceId(ManagementResourceGroup, 'Microsoft.DesktopVirtualization/hostpools', HostPoolName), '2019-12-10-preview').registrationInfo.token} -ImageOffer ${ImageOffer} -ImagePublisher ${ImagePublisher} -NetAppFileShares ${NetAppFileShares} -NvidiaVmSize ${NvidiaVmSize} -PooledHostPool ${PooledHostPool} -RdpShortPath ${RdpShortPath} -ScreenCaptureProtection ${ScreenCaptureProtection} -Sentinel ${Sentinel} -SentinelWorkspaceId ${SentinelWorkspaceId} -SentinelWorkspaceKey ${SentinelWorkspaceKey} -StorageAccountPrefix ${StorageAccountPrefix} -StorageCount ${StorageCount} -StorageIndex ${StorageIndex} -StorageSolution ${StorageSolution} -StorageSuffix ${StorageSuffix}
// -csAgentPackageLocation ${csAgentPackageLocation} 

// =========== //
// Deployments //
// =========== //

// Clean up deployment temporary resources.
resource postDeploymentTempResourcesCleanUp 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  name: '${managementVmName}/DeploymentCleanUp'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        //'${_artifactsLocation}Set-SessionHostConfiguration.ps1${_artifactsLocationSasToken}'
        '${scriptUri}'
      ]
      timestamp: time
    }
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File ${scriptFile} ${varPostDeploymentTempResuorcesCleanUpScriptArgs}'
    }
  }
  tags: tags
}
