metadata name = 'Dev Center Project Environment Type'
metadata description = 'This module deploys a Dev Center Project Environment Type.'

// ================ //
// Parameters       //
// ================ //

@sys.description('Required. The name of the environment type.')
@minLength(3)
@maxLength(63)
param name string

@sys.description('Conditional. The name of the parent dev center project. Required if the template is used in a standalone deployment.')
param projectName string

@sys.description('Optional. The display name of the environment type.')
param displayName string?

// Note: Description property is not supported in the EnvironmentType schema

@sys.description('Optional. Id of a subscription that the environment type will be mapped to. The environment\'s resources will be deployed into this subscription.')
param deploymentTargetId string?

@sys.description('Optional. Defines whether this Environment Type can be used in this Project.')
@allowed([
  'Enabled'
  'Disabled'
])
param status string?

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. The role definition assigned to the environment creator on backing resources.')
param creatorRoleAssignment creatorRoleAssignmentType?

@sys.description('Optional. Role Assignments created on environment backing resources. This is a mapping from a user object ID to an object of role definition IDs.')
param userRoleAssignments userRoleAssignmentsType?

@sys.description('Optional. Tags of the resource.')
param tags object?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

// ============== //
// Resources      //
// ============== //

resource project 'Microsoft.DevCenter/projects@2025-02-01' existing = {
  name: projectName
}

resource environmentType 'Microsoft.DevCenter/projects/environmentTypes@2025-02-01' = {
  parent: project
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    displayName: displayName
    deploymentTargetId: deploymentTargetId
    status: status
    creatorRoleAssignment: creatorRoleAssignment
    userRoleAssignments: userRoleAssignments
  }
}

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the environment type.')
output resourceId string = environmentType.id

@sys.description('The name of the environment type.')
output name string = environmentType.name

@sys.description('The name of the resource group the environment type was created in.')
output resourceGroupName string = resourceGroup().name

@sys.description('The location the resource was deployed into.')
output location string = environmentType.location

@sys.description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = environmentType.?identity.?principalId

// ================ //
// Definitions      //
// ================ //

@sys.description('The type for the creator role assignment.')
@export()
type creatorRoleAssignmentType = {
  @sys.description('A map of roles to assign to the environment creator.')
  roles: {
    @sys.description('The role assignment properties.')
    *: environmentRoleType
  }
}

@sys.description('The type for the environment role.')
@export()
type environmentRoleType = {
  @sys.description('The description of the Role Assignment.')
  description: string?

  @sys.description('The common name of the Role Assignment. This is a descriptive name such as \'AcrPush\'.')
  roleName: string?
}

@sys.description('The type for user role assignments.')
@export()
type userRoleAssignmentsType = {
  @sys.description('User role assignment value.')
  *: userRoleAssignmentValueType
}

@sys.description('The type for user role assignment value.')
@export()
type userRoleAssignmentValueType = {
  @sys.description('A map of roles to assign to the parent user.')
  roles: {
    @sys.description('The role assignment properties.')
    *: environmentRoleType
  }
}
