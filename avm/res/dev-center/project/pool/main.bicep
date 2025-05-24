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

@description('Optional. The managed virtual network regions for the pool.')
param managedVirtualNetworkRegions array = []

@description('Optional. The single sign-on status for the pool.')
@allowed([
  'Enabled'
  'Disabled'
])
param singleSignOnStatus string = 'Disabled'

@description('Optional. The virtual network type for the pool.')
param virtualNetworkType string?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

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
    displayName: displayName
    devBoxDefinitionName: devBoxDefinitionResourceId
    networkConnectionName: networkConnectionResourceId
    licenseType: licenseType
    localAdministrator: localAdministrator
    managedVirtualNetworkRegions: managedVirtualNetworkRegions
    singleSignOnStatus: singleSignOnStatus
    virtualNetworkType: virtualNetworkType
    // stopOnDisconnect and stopOnNoConnect omitted for now
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

// NOTE: The following parameters are commented out because they are not currently supported by the Bicep type system for this resource:
// param poolDescription string?
// param size string = 'medium'
// param maxDevBoxes int = 0
// param hibernateEnabled bool = false
// param stopEnabled bool = false
// param singleSignOnEnabled bool = false
// param autoAssignmentEnabled bool = false
// param allowedRegions array = []
// param allowedImageReferences array = []
// param allowedSkuReferences array = []
//
// If/when Bicep supports these, add them to the resource definition and parameters.

// Remove stopOnDisconnect and stopOnNoConnect for now, as they require complex types not currently handled here.

// ================ //
// Definitions      //
// ================ //
//
// NOTE: When Bicep supports complex types for managedVirtualNetworkRegions, use the following type:
// @description('The type for managed virtual network regions.')
// @export()
// type managedVirtualNetworkRegionType = {
//   @description('The Azure region name.')
//   region: string
//   @description('The subnet resource ID.')
//   subnetId: string
// }
