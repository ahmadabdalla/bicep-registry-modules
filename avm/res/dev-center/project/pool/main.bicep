metadata name = 'Dev Center Project Pool'
metadata description = 'This module deploys a Dev Center Project Pool.'

// ================ //
// Parameters       //
// ================ //

@description('Required. The name of the project pool.')
@minLength(3)
@maxLength(63)
param name string

@description('Conditional. The name of the parent dev center project. Required if the template is used in a standalone deployment.')
param projectName string

@description('Optional. The display name of the pool.')
param displayName string?

@description('Required. The resource ID of the dev box definition to use for this pool.')
param devBoxDefinitionResourceId string

@description('Required. The resource ID of the network connection to use for this pool.')
param networkConnectionResourceId string

@description('Optional. The license type to use for this pool. Allowed values: Windows_Client, Windows_Server.')
@allowed([
  'Windows_Client'
  'Windows_Server'
])
param licenseType string = 'Windows_Client'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags to apply to the pool.')
param tags object?

@description('Optional. The local administrator setting for the pool.')
param localAdministrator string?

@description('Optional. The managed virtual network region for the pool.')
param managedVirtualNetworkRegions string[] = []

@description('Optional. The single sign-on status for the pool.')
@allowed([
  'Enabled'
  'Disabled'
])
param singleSignOnStatus string = 'Disabled'

@description('Optional. The virtual network type for the pool.')
param virtualNetworkType string?

@description('Optional. Configuration for stop on disconnect.')
param stopOnDisconnect StopOnDisconnectConfiguration?

@description('Optional. Configuration for stop on no connect.')
param stopOnNoConnect StopOnNoConnectConfiguration?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Required. The SKU configuration for the dev box definition.')
param sku DevBoxSkuConfiguration

@description('Required. The resource ID of the image reference for the dev box definition.')
param imageReferenceResourceId string

@description('Required. The type of the dev box definition.')
param devBoxDefinitionType string

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: roleAssignment.roleDefinitionIdOrName
  })
]

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
    devBoxDefinitionName: devBoxDefinitionResourceId
    devBoxDefinitionType: devBoxDefinitionType
    displayName: displayName
    licenseType: licenseType
    localAdministrator: localAdministrator
    managedVirtualNetworkRegions: managedVirtualNetworkRegions // Correctly referenced parameter
    networkConnectionName: networkConnectionResourceId
    singleSignOnStatus: singleSignOnStatus
    stopOnDisconnect: stopOnDisconnect ?? {
      gracePeriodMinutes: 0
      status: 'Disabled'
    }
    stopOnNoConnect: stopOnNoConnect
    virtualNetworkType: virtualNetworkType
  }
}

resource pool_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(pool.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: pool
  }
]

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
  @description('Required. The grace period in minutes before stopping the session after a disconnect.')
  gracePeriodMinutes: int
  @description('Required. The status of the stop on disconnect configuration. Allowed values: Enabled, Disabled.')
  status: 'Enabled' | 'Disabled'
}

@description('The type for stopOnNoConnect configuration.')
@export()
type StopOnNoConnectConfiguration = {
  @description('Required. The grace period in minutes before stopping the session when no connection is established.')
  gracePeriodMinutes: int
  @description('Required. The status of the stop on no connect configuration. Allowed values: Enabled, Disabled.')
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
type DevBoxSkuConfiguration = {
  @description('Required. The capacity of the SKU.')
  capacity: int
  @description('Required. The family of the SKU.')
  family: string
  @description('Required. The name of the SKU.')
  name: string
  @description('Required. The size of the SKU.')
  size: string
  @description('Required. The tier of the SKU. Allowed values: Basic, Free, Premium, Standard.')
  tier: 'Basic' | 'Free' | 'Premium' | 'Standard'
}
