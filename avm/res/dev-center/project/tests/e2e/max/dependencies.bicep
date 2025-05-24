@description('Required. The name of the Dev Center.')
param devCenterName string

@description('Required. The name of the Dev Center Environment Type to create.')
param environmentTypeName string

@description('Required. The name of the first Managed Identity to create.')
param managedIdentity1Name string

@description('Required. The name of the second Managed Identity to create.')
param managedIdentity2Name string

@description('Required. The name of the custom role definition to create.')
param roleDefinitionName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource managedIdentity1 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentity1Name
  location: location
}

resource managedIdentity2 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentity2Name
  location: location
}

resource devCenter 'Microsoft.DevCenter/devcenters@2025-02-01' = {
  name: devCenterName
  location: location
  properties: {
    projectCatalogSettings: {
      catalogItemSyncEnableStatus: 'Enabled'
    }
  }
}

resource environmentType 'Microsoft.DevCenter/devcenters/environmentTypes@2025-02-01' = {
  name: environmentTypeName
  parent: devCenter
  tags: {
    env: 'sandbox'
  }
  properties: {
    displayName: 'Sandbox'
  }
}

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(resourceGroup().id, 'DevCenterReader')
  properties: {
    roleName: roleDefinitionName
    description: 'Allows users to read Dev Center resources.'
    type: 'CustomRole'
    assignableScopes: [
      resourceGroup().id
    ]
    permissions: [
      {
        actions: [
          'Microsoft.DevCenter/devcenters/read'
        ]
      }
    ]
  }
}

@description('The resource ID of the created DevCenter.')
output devCenterResourceId string = devCenter.id

@description('The principal ID of the first created Managed Identity.')
output managedIdentity1PrincipalId string = managedIdentity1.properties.principalId

@description('The resource ID of the first created Managed Identity.')
output managedIdentityResourceId string = managedIdentity1.id

@description('The principal ID of the second created Managed Identity.')
output managedIdentity2PrincipalId string = managedIdentity2.properties.principalId

@description('The resource ID of the second created Managed Identity.')
output managedIdentity2ResourceId string = managedIdentity2.id

@description('The resource ID of the custom role definition.')
output roleDefinitionResourceId string = roleDefinition.id

@description('The name of the created custom role definition.')
output roleDefinitionId string = roleDefinition.name
