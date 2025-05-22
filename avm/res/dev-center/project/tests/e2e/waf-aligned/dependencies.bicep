@description('Required. The name of the Dev Center.')
param devCenterName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource devCenter 'Microsoft.DevCenter/devcenters@2025-02-01' = {
  name: devCenterName
  location: location
  properties: {}
}

@description('The resource ID of the created DevCenter.')
output devCenterResourceId string = devCenter.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
