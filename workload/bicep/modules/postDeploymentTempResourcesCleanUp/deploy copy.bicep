// ========== //
// Parameters //
// ========== //

@description('Location where to deploy compute services.')
param location string

@description('Location for the AVD agent installation package.')
param baseScriptUri string

@description('Azure cloud.')
param azureCloudName string

@description('Virtual machine name to deploy the DSC extension to.')
param managementVmName string

@description('Tags to be applied to resources')
param tags object

@description('Script file name.')
param scriptFile string

@description('DSC package location.')
param dscAgentPackageLocation string

@description('Session host VM size.')
param sessionHostsSize string

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
var AmdVmSizes = [
  'Standard_NV4as_v4'
  'Standard_NV8as_v4'
  'Standard_NV16as_v4'
  'Standard_NV32as_v4'
]
var varAmdVmSku = contains(AmdVmSizes, sessionHostsSize)
var NvidiaVmSizes = [
  'Standard_NV6'
  'Standard_NV12'
  'Standard_NV24'
  'Standard_NV12s_v3'
  'Standard_NV24s_v3'
  'Standard_NV48s_v3'
  'Standard_NC4as_T4_v3'
  'Standard_NC8as_T4_v3'
  'Standard_NC16as_T4_v3'
  'Standard_NC64as_T4_v3'
  'Standard_NV6ads_A10_v5'
  'Standard_NV12ads_A10_v5'
  'Standard_NV18ads_A10_v5'
  'Standard_NV36ads_A10_v5'
  'Standard_NV36adms_A10_v5'
  'Standard_NV72ads_A10_v5'
]
var varNvidiaVmSku = contains(NvidiaVmSizes, sessionHostsSize)
var varPostDeploymentTempResuorcesCleanUpScriptArgs = '-dscPath ${dscAgentPackageLocation} -subscriptionId ${subscriptionId} -serviceObjectsRgName ${serviceObjectsRgName} -computeObjectsRgName ${computeObjectsRgName} -storageObjectsRgName ${storageObjectsRgName} -networkObjectsRgName ${networkObjectsRgName} -monitoringObjectsRgName ${monitoringObjectsRgName} -azureCloudEnvironment ${azureCloudName} -managmentVmName ${managementVmName} -AmdVmSize ${varAmdVmSku} -Environment ${environment().name} -Verbose'
//-DisaStigCompliance ${DisaStigCompliance}  -FSLogix ${Fslogix} -FslogixSolution ${FslogixSolution} -HostPoolName ${HostPoolName} -HostPoolRegistrationToken ${reference(resourceId(ManagementResourceGroup, 'Microsoft.DesktopVirtualization/hostpools', HostPoolName), '2019-12-10-preview').registrationInfo.token} -ImageOffer ${ImageOffer} -ImagePublisher ${ImagePublisher} -NetAppFileShares ${NetAppFileShares} -NvidiaVmSize ${NvidiaVmSize} -PooledHostPool ${PooledHostPool} -RdpShortPath ${RdpShortPath} -ScreenCaptureProtection ${ScreenCaptureProtection} -Sentinel ${Sentinel} -SentinelWorkspaceId ${SentinelWorkspaceId} -SentinelWorkspaceKey ${SentinelWorkspaceKey} -StorageAccountPrefix ${StorageAccountPrefix} -StorageCount ${StorageCount} -StorageIndex ${StorageIndex} -StorageSolution ${StorageSolution} -StorageSuffix ${StorageSuffix}

// =========== //
// Deployments //
// =========== //

// Clean up deployment temporary resources.
resource deploymentCleanUp 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  name: '${managementVmName}/DeploymentCleanUp'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        '${_artifactsLocation}Set-SessionHostConfiguration.ps1${_artifactsLocationSasToken}'
      ]
      timestamp: time
    }
  //  protectedSettings: {
  //    commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File Set-SessionHostConfiguration.ps1  '
  //  }
  }
  tags: tags
}
