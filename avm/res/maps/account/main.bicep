metadata name = 'Azure Maps Account'
metadata description = 'This module deploys an Azure Maps Account.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@allowed(['G2'])
@description('Optional. The SKU of the Maps Account. Default is G2.')
param sku string = 'G2'

@description('Optional. The kind of the Maps Account. Default is Gen2.')
param kind string = 'Gen2'

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Optional. Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.')
@allowed(['enabled', 'disabled'])
param requireInfrastructureEncryption string = 'disabled'

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
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

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[2],
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[4]
  )
}

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split(customerManagedKey.?keyVaultResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource mapsAccount 'Microsoft.Maps/accounts@2024-07-01-preview' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  identity: identity
  kind: kind
  properties: {
    encryption: !empty(customerManagedKey)
      ? {
          customerManagedKeyEncryption: {
            keyEncryptionKeyIdentity: {
              userAssignedIdentityResourceId: !empty(customerManagedKey.?userAssignedIdentityResourceId)
                ? cMKUserAssignedIdentity.id
                : null
              identityType: !empty(customerManagedKey.?userAssignedIdentityResourceId)
                ? 'userAssignedIdentity'
                : 'systemAssignedIdentity'
            }
            keyEncryptionKeyUrl: !empty(customerManagedKey.?keyVersion ?? '')
              ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
              : (customerManagedKey.?autoRotationEnabled ?? true)
                  ? cMKKeyVault::cMKKey.properties.keyUri
                  : cMKKeyVault::cMKKey.properties.keyUriWithVersion
          }
          infrastructureEncryption: requireInfrastructureEncryption // Property renamed
        }
      : {}
  }
}
