metadata name = 'Dev Center Project Pool'
metadata description = 'This module deploys a Dev Center Project Pool.'

// ================ //
// Parameters       //
// ================ //

@description('Required. The name of the project pool. This name must be unique within a project and is visible to developers when creating dev boxes.')
@minLength(3)
@maxLength(63)
param name string

@description('Conditional. The name of the parent dev center project. Required if the template is used in a standalone deployment.')
param projectName string

@description('Optional. The display name of the pool.')
param displayName string?

@description('Required. Indicates if the pool is created from an existing Dev Box Definition or if one is provided directly.')
param devBoxDefinitionType string

@description('Optional. Name of a Dev Box definition in parent Project of this Pool. Will be ignored if devBoxDefinitionType is "Value".')
param devBoxDefinitionName string?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags to apply to the pool.')
param tags object?

@description('Optional. Indicates whether owners of Dev Boxes in this pool are added as local administrators on the Dev Box.')
@allowed([
  'Enabled'
  'Disabled'
])
param localAdministrator string?

@description('Conditional. The regions of the managed virtual network. Required when managedNetworkType is "Managed".')
param managedVirtualNetworkRegions string[]?

@description('Optional. Name of a Network Connection in parent Project of this Pool.')
param networkConnectionName string?

@description('Optional. Indicates whether Dev Boxes in this pool are created with single sign on enabled. The also requires that single sign on be enabled on the tenant.')
@allowed([
  'Enabled'
  'Disabled'
])
param singleSignOnStatus string = 'Disabled'

@description('Optional. Stop on disconnect configuration settings for Dev Boxes created in this pool.')
param stopOnDisconnect StopOnDisconnectConfiguration?

@description('Optional. Stop on no connect configuration settings for Dev Boxes created in this pool.')
param stopOnNoConnect StopOnNoConnectConfiguration?

@description('Optional. Indicates whether the pool uses a Virtual Network managed by Microsoft or a customer provided network.')
@allowed([
  'Managed'
  'Unmanaged'
])
param virtualNetworkType string?

@description('Required. The SKU for Dev Boxes created from the Pool.')
param sku skuType

@description('Required. The resource ID of the image reference for the dev box definition. This defines the base image for the dev boxes.')
param imageReferenceResourceId string

// ============== //
// Resources      //
// ============== //

resource project 'Microsoft.DevCenter/projects@2025-02-01' existing = {
  name: projectName
}

resource pool 'Microsoft.DevCenter/projects/pools@2025-02-01' = {
  name: name
  parent: project
  location: location
  tags: tags
  properties: {
    devBoxDefinition: {
      imageReference: {
        id: imageReferenceResourceId
      }
      sku: sku
    }
    devBoxDefinitionName: devBoxDefinitionName
    devBoxDefinitionType: devBoxDefinitionType
    displayName: displayName
    licenseType: 'Windows_Client'
    localAdministrator: localAdministrator
    managedVirtualNetworkRegions: managedVirtualNetworkRegions
    networkConnectionName: networkConnectionName
    singleSignOnStatus: singleSignOnStatus
    stopOnDisconnect: stopOnDisconnect ?? {
      gracePeriodMinutes: 0
      status: 'Disabled'
    }
    stopOnNoConnect: stopOnNoConnect
    virtualNetworkType: virtualNetworkType
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the pool.')
output resourceId string = pool.id

@description('The name of the pool.')
output name string = pool.name

@description('The name of the resource group the pool was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = pool.location

// ================ //
// Definitions      //
// ================ //

@description('The type for stopOnDisconnect configuration.')
@export()
type StopOnDisconnectConfiguration = {
  @description('Required. The specified time in minutes to wait before stopping a Dev Box once disconnect is detected.')
  gracePeriodMinutes: int

  @description('Required. Whether the feature to stop the Dev Box on disconnect once the grace period has lapsed is enabled.')
  status: 'Enabled' | 'Disabled'
}

@description('The type for stopOnNoConnect configuration.')
@export()
type StopOnNoConnectConfiguration = {
  @description('Required. The specified time in minutes to wait before stopping a Dev Box if no connection is made.')
  gracePeriodMinutes: int

  @description('Required. Enables the feature to stop a started Dev Box when it has not been connected to, once the grace period has lapsed.')
  status: 'Enabled' | 'Disabled'
}

@description('The type for managed virtual network regions.')
@export()
type ManagedVirtualNetworkRegionType = {
  @description('Required. The region of the managed virtual network.')
  region: string

  @description('Required. The subnet ID of the managed virtual network.')
  subnetId: string
}

@description('The type for SKU configuration of the dev box definition.')
@export()
type skuType = {
  @description('Optional. If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.')
  capacity: int?

  @description('Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here.')
  family: string?

  @description('Required. The name of the SKU. E.g. P3. It is typically a letter+number code.')
  name: string

  @description('Optional. The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.')
  size: string?
}
