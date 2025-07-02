metadata name = 'Dev Center'
metadata description = 'This module deploys an Azure Dev Center.'

@description('Required. Name of the Dev Center.')
@minLength(3)
@maxLength(26)
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

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

resource devcenter 'Microsoft.DevCenter/devcenters@2025-02-01' = {
  name: name
  location: location
  identity: identity
  properties: {
    //...(!empty(customerManagedKey)
    //  ? {
    //      encryption: {
    //        customerManagedKeyEncryption: {
    //          keyEncryptionKeyIdentity: {
    //            userAssignedIdentityResourceId: !empty(customerManagedKey.?userAssignedIdentityResourceId)
    //              ? cMKUserAssignedIdentity.id
    //              : null
    //            identityType: !empty(customerManagedKey.?userAssignedIdentityResourceId)
    //              ? 'userAssignedIdentity'
    //              : 'systemAssignedIdentity'
    //          }
    //          keyEncryptionKeyUrl: !empty(customerManagedKey.?keyVersion ?? '')
    //            ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
    //            : (customerManagedKey.?autoRotationEnabled ?? true)
    //                ? cMKKeyVault::cMKKey.properties.keyUri
    //                : cMKKeyVault::cMKKey.properties.keyUriWithVersion
    //        }
    //      }
    //    }
    //  : {})
    encryption: !empty(customerManagedKey) ? null : null
    //encryption: !empty(customerManagedKey)
    //  ? {
    //      customerManagedKeyEncryption: {
    //        keyEncryptionKeyIdentity: {
    //          userAssignedIdentityResourceId: !empty(customerManagedKey.?userAssignedIdentityResourceId)
    //            ? cMKUserAssignedIdentity.id
    //            : null
    //          identityType: !empty(customerManagedKey.?userAssignedIdentityResourceId)
    //            ? 'userAssignedIdentity'
    //            : 'systemAssignedIdentity'
    //        }
    //        keyEncryptionKeyUrl: !empty(customerManagedKey.?keyVersion ?? '')
    //          ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
    //          : (customerManagedKey.?autoRotationEnabled ?? true)
    //              ? cMKKeyVault::cMKKey.properties.keyUri
    //              : cMKKeyVault::cMKKey.properties.keyUriWithVersion
    //      }
    //    }
    //  : {}
    //encryption: {
    //  customerManagedKeyEncryption: {
    //    keyEncryptionKeyIdentity: {
    //      userAssignedIdentityResourceId: !empty(customerManagedKey.?userAssignedIdentityResourceId)
    //        ? cMKUserAssignedIdentity.id
    //        : null
    //      identityType: !empty(customerManagedKey.?userAssignedIdentityResourceId)
    //        ? 'userAssignedIdentity'
    //        : 'systemAssignedIdentity'
    //    }
    //    keyEncryptionKeyUrl: !empty(customerManagedKey.?keyVersion ?? '')
    //      ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
    //      : (customerManagedKey.?autoRotationEnabled ?? true)
    //          ? cMKKeyVault::cMKKey.properties.keyUri
    //          : cMKKeyVault::cMKKey.properties.keyUriWithVersion
    //  }
    //}
  }
}
