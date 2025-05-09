metadata name = 'Azure Dev Center Plan'
metadata description = 'This module deploys an Azure Dev Center Plan.'

@sys.description('The name of the Azure Dev Center Plan.')
@minLength(3)
@maxLength(63)
param name string

@sys.description('The location to deploy the Azure Dev Center Plan.')
param location string = resourceGroup().location

@sys.description('Tags to apply to the Azure Dev Center Plan.')
param tags object = {}

@sys.description('Specifies the SKU name of the Dev Center Plan. E.g. P3.')
param skuName string

@sys.description('Specifies the SKU tier of the Dev Center Plan. E.g. Standard, Premium.')
@allowed([
  'Basic'
  'Free'
  'Premium'
  'Standard'
])
param skuTier string?

@sys.description('Specifies the SKU size of the Dev Center Plan.')
param skuSize string?

@sys.description('Specifies the SKU family of the Dev Center Plan.')
param skuFamily string?

@sys.description('Specifies the SKU capacity of the Dev Center Plan if scale out/in is supported.')
param skuCapacity int?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

// =========== //
// VARIABLES   //
// =========== //

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

// =========== //
// RESOURCES   //
// =========== //

resource plan 'Microsoft.DevCenter/plans@2024-10-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
    size: skuSize
    family: skuFamily
    capacity: skuCapacity
  }
  properties: {}
}

resource plan_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: plan
}

resource plan_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(plan.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: plan
  }
]

// =========== //
// OUTPUTS     //
// =========== //

@sys.description('The resource ID of the Azure Dev Center Plan.')
output resourceId string = plan.id

@sys.description('The name of the Azure Dev Center Plan.')
output name string = plan.name

@sys.description('The resource group the Azure Dev Center Plan was deployed into.')
output resourceGroupName string = resourceGroup().name
