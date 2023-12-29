targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.privatelinkscopes-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'iplswaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-la-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //
var locationUpdated = toLower(replace(location, ' ', ''))

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: 'global'
    scopedResources: [
      {
        name: 'scoped1'
        linkedResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
      }
    ]
    privateEndpoints: [
      {
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        ipConfigurations: [
          {
            name: 'api'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'api'
              privateIPAddress: '10.0.0.11'
            }
          }
          {
            name: 'globalinai'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'global.in.ai'
              privateIPAddress: '10.0.0.12'
            }
          }
          {
            name: 'profiler'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'profiler'
              privateIPAddress: '10.0.0.13'
            }
          }
          {
            name: 'live'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'live'
              privateIPAddress: '10.0.0.14'
            }
          }
          {
            name: 'diagservicesquery'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'diagservicesquery'
              privateIPAddress: '10.0.0.15'
            }
          }
          {
            name: 'snapshot'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'snapshot'
              privateIPAddress: '10.0.0.16'
            }
          }
          {
            name: 'agentsolutionpackstore'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'agentsolutionpackstore'
              privateIPAddress: '10.0.0.17'
            }
          }
          {
            name: 'dce-global'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'dce-global'
              privateIPAddress: '10.0.0.18'
            }
          }
          {
            name: 'oms-${locationUpdated}'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'oms-${locationUpdated}'
              privateIPAddress: '10.0.0.19'
            }
          }
          {
            name: 'ods-${locationUpdated}'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'ods-${locationUpdated}'
              privateIPAddress: '10.0.0.20'
            }
          }
          {
            name: 'agent-${locationUpdated}'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'agent-${locationUpdated}'
              privateIPAddress: '10.0.0.21'
            }
          }
        ]
        customDnsConfigs: [
          {
            fqdn: 'abc.azuremonitor.com'
            ipAddresses: [
              '10.0.0.10'
            ]
          }
        ]
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Owner'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
  }
}]
