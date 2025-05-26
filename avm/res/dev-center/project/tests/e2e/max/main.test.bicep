targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-devcenter.project-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dcpmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// Hardcoded because service not available in all regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    devCenterName: 'dep-${namePrefix}-dc-${serviceShort}'
    devCenterNetworkConnectionName: 'dep-${namePrefix}-dcnc-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    environmentTypeName: 'dep-${namePrefix}-et-${serviceShort}'
    managedIdentity1Name: 'dep-${namePrefix}-msi1-${serviceShort}'
    managedIdentity2Name: 'dep-${namePrefix}-msi2-${serviceShort}'
    roleDefinitionName: 'dep-${namePrefix}-customrole-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      displayName: 'My Dev Center Project'
      description: 'This is a test project for the Dev Center project module.'
      devCenterResourceId: nestedDependencies.outputs.devCenterResourceId
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      //lock: { restore once development work is done
      //  kind: 'CanNotDelete'
      //  name: 'myCustomLockName'
      //}
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      roleAssignments: [
        {
          principalId: nestedDependencies.outputs.managedIdentity1PrincipalId
          roleDefinitionIdOrName: 'DevCenter Project Admin'
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentity1PrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentity1PrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      catalogSettings: {
        catalogItemSyncTypes: [
          'EnvironmentDefinition'
          'ImageDefinition'
        ]
      }
      maxDevBoxesPerUser: 2
      environmentTypes: [
        {
          name: 'dep-${namePrefix}-et-${serviceShort}'
          displayName: 'My Sandbox Environment Type'
          status: 'Enabled'
          deploymentTargetSubscriptionResourceId: subscription().id
          tags: {
            'prj-type': 'sandbox'
          }
          managedIdentities: {
            systemAssigned: false
            userAssignedResourceIds: [
              nestedDependencies.outputs.managedIdentityResourceId
            ]
          }
          roleAssignments: [
            {
              principalId: nestedDependencies.outputs.managedIdentity1PrincipalId
              roleDefinitionIdOrName: 'DevCenter Project Admin'
              principalType: 'ServicePrincipal'
            }
          ]
          creatorRoleAssignmentRoles: [
            'acdd72a7-3385-48ef-bd42-f606fba81ae7' // 'Reader'
            'b24988ac-6180-42a0-ab88-20f7382dd24c' // 'Contributor'
          ]
          userRoleAssignmentsRoles: [
            {
              objectId: nestedDependencies.outputs.managedIdentity1PrincipalId
              roleDefinitions: [
                'e503ece1-11d0-4e8e-8e2c-7a6c3bf38815' // 'AzureML Compute Operator'
                'b59867f0-fa02-499b-be73-45a86b5b3e1c' // 'Cognitive Services Data Reader'
              ]
            }
            {
              objectId: nestedDependencies.outputs.managedIdentity2PrincipalId
              roleDefinitions: [
                nestedDependencies.outputs.roleDefinitionId // Custom role
              ]
            }
          ]
        }
      ]
      pools: [
        {
          name: 'sandbox-pool'
          devBoxDefinitionType: 'Reference'
          devBoxDefinitionName: nestedDependencies.outputs.devboxDefinitionName
          localAdministrator: 'Enabled'
          virtualNetworkType: 'Managed'
          singleSignOnStatus: 'Enabled'
          stopOnDisconnect: {
            gracePeriodMinutes: 60
            status: 'Enabled'
          }
          stopOnNoConnect: {
            gracePeriodMinutes: 30
            status: 'Enabled'
          }
          managedVirtualNetworkRegion: 'australiaeast'
          schedule: {
            state: 'Enabled'
            time: '18:30'
            timeZone: 'Australia/Sydney'
          }
        }
      ]
    }
  }
]
