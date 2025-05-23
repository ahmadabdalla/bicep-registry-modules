metadata name = 'Dev Center Project Environment Type'
metadata description = 'This module deploys a Dev Center Project Environment Type.'

// ================ //
// Parameters       //
// ================ //

@sys.description('Required. The name of the environment type. The environment type must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center.')
@minLength(3)
@maxLength(63)
param name string

@sys.description('Conditional. The name of the parent dev center project. Required if the template is used in a standalone deployment.')
param projectName string

@sys.description('Optional. The display name of the environment type.')
param displayName string?

@sys.description('Required. The subscription Resource ID where the environment type will be mapped to. The environment\'s resources will be deployed into this subscription. Should be in the format "/subscriptions/{subscriptionId}".')
param deploymentTargetSubscriptionResourceId string

@sys.description('Optional. Defines whether this Environment Type can be used in this Project. The default is "Enabled".')
@allowed([
  'Enabled'
  'Disabled'
])
param status string = 'Enabled'

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Required. Specifies the role definitions (permissions) that will be granted to the user that creates a given environment of this type.')
param creatorRoleAssignment creatorRoleAssignmentType

@sys.description('Optional. Role Assignments created on environment backing resources. This is a mapping from a user object ID to an object of role definition IDs.')
param userRoleAssignments userRoleAssignmentsType?

@sys.description('Optional. Resource tags to apply to the environment type.')
param tags object?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The managed identity definition for this resource. If using user assigned identities, they must be first associated to the project that this environment type is created in and only one user identity can be used per project. At least one identity (system assigned or user assigned) must be enabled for deployment. The default is set to system assigned identity.')
param managedIdentities managedIdentityAllType = {
  systemAssigned: true
}

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
    deploymentTargetId: deploymentTargetSubscriptionResourceId
    status: status
    creatorRoleAssignment: creatorRoleAssignment
    //userRoleAssignments: userRoleAssignments
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
  @sys.description('Required. A map of roles to assign to the environment creator.')
  roles: {
    @sys.description('Required. The role assignment properties.')
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
