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

@description('Optional. Indicates if the pool is created from an existing Dev Box Definition or if one is provided directly.')
@allowed([
  'Reference'
  'Value'
])
param devBoxDefinitionType string = 'Reference'

@description('Conditional. Name of a Dev Box definition in parent Project of this Pool. Required if devBoxDefinitionType is "Reference".')
param devBoxDefinitionName string?

@description('Conditional. A definition of the machines that are created from this Pool. Required if devBoxDefinitionType is "Value".')
param devBoxDefinition devBoxDefinitionTypeType?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags to apply to the pool.')
param tags object?

@description('Required. Each dev box creator will be granted the selected permissions on the dev boxes they create. Indicates whether owners of Dev Boxes in this pool are added as a "local administrator" or "standard user" on the Dev Box.')
@allowed([
  'Enabled'
  'Disabled'
])
param localAdministrator string

@description('Required. Indicates whether the pool uses a Virtual Network managed by Microsoft or a customer provided network. For the easiest configuration experience, the Microsoft hosted network can be used for dev box deployment. For organizations that require customized networking, use a network connection resource.')
@allowed([
  'Managed'
  'Unmanaged'
])
param virtualNetworkType string

@description('Conditional. The region of the managed virtual network. Required if virtualNetworkType is "Managed".')
param managedVirtualNetworkRegion string?

@description('Conditional. Name of a Network Connection in parent Project of this Pool. Required if virtualNetworkType is "Unmanaged". The region hosting a pool is determined by the region of the network connection. For best performance, create a dev box pool for every region where your developers are located. The network connection cannot be configured with "None" domain join type and must be first attached to the Dev Center before used by the pool. Will be set to "managedNetwork" if virtualNetworkType is "Managed".')
param networkConnectionName string?

@description('Optional. Indicates whether Dev Boxes in this pool are created with single sign on enabled. The also requires that single sign on be enabled on the tenant. Changing this setting will not affect existing dev boxes.')
@allowed([
  'Enabled'
  'Disabled'
])
param singleSignOnStatus string?

@description('Optional. Stop on "disconnect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period after the user disconnects.')
param stopOnDisconnect stopOnDisconnectConfiguration?

@description('Optional. Stop on "no connect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period if the user never connects.')
param stopOnNoConnect stopOnNoConnectConfiguration?

@description('Optional. The schedule for the pool. Dev boxes in this pool will auto-stop every day as per the schedule configuration.')
param schedule poolScheduleType?

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
    devBoxDefinition: devBoxDefinitionType == 'Value'
      ? {
          imageReference: {
            id: devBoxDefinition.?imageReferenceResourceId
          }
          sku: devBoxDefinition.?sku
        }
      : null
    devBoxDefinitionName: devBoxDefinitionName
    devBoxDefinitionType: devBoxDefinitionType
    displayName: displayName
    licenseType: 'Windows_Client'
    localAdministrator: localAdministrator
    managedVirtualNetworkRegions: virtualNetworkType == 'Managed' ? [managedVirtualNetworkRegion!] : null
    networkConnectionName: virtualNetworkType == 'Unmanaged' ? networkConnectionName : 'managedNetwork'
    singleSignOnStatus: singleSignOnStatus
    stopOnDisconnect: stopOnDisconnect
    stopOnNoConnect: stopOnNoConnect
    virtualNetworkType: virtualNetworkType
  }
}

module pool_schedule 'schedule/main.bicep' = if (schedule != null) {
  name: '${uniqueString(deployment().name, location)}-Pool-Schedule'
  params: {
    state: schedule!.state
    time: schedule!.time
    timeZone: schedule!.timeZone
    poolName: pool.name
    projectName: project.name
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
type stopOnDisconnectConfiguration = {
  @description('Required. The specified time in minutes to wait before stopping a Dev Box once disconnect is detected.')
  gracePeriodMinutes: int

  @description('Required. Whether the feature to stop the Dev Box on disconnect once the grace period has lapsed is enabled.')
  status: 'Enabled' | 'Disabled'
}

@description('The type for stopOnNoConnect configuration.')
@export()
type stopOnNoConnectConfiguration = {
  @description('Required. The specified time in minutes to wait before stopping a Dev Box if no connection is made.')
  gracePeriodMinutes: int

  @description('Required. Enables the feature to stop a started Dev Box when it has not been connected to, once the grace period has lapsed.')
  status: 'Enabled' | 'Disabled'
}

@description('The type for dev box definition.')
@export()
type devBoxDefinitionTypeType = {
  @description('Required. The resource ID of the image reference for the dev box definition.')
  imageReferenceResourceId: string

  @description('Required. The SKU configuration for the dev box definition.')
  sku: {
    @description('Optional. If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.')
    capacity: int?

    @description('Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here.')
    family: string?

    @description('Required. The name of the SKU. E.g. P3. It is typically a letter+number code.')
    name: string

    @description('Optional. The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.')
    size: string?
  }
}

@description('The type for the pool schedule.')
@export()
type poolScheduleType = {
  @description('Required. Indicates whether or not this scheduled task is enabled. Allowed values: Disabled, Enabled.')
  state: 'Disabled' | 'Enabled'

  @description('Required. The target time to trigger the action. The format is HH:MM. For example, "14:30" for 2:30 PM.')
  time: string

  @description('Required. The IANA timezone id at which the schedule should execute. For example, "Australia/Sydney", "Canada/Central".')
  timeZone: string
}
