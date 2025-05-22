# Dev Center Project `[Microsoft.DevCenter/projects]`

This module deploys a Dev Center Project.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DevCenter/projects` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/dev-center/project:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module project 'br/public:avm/res/dev-center/project:<version>' = {
  name: 'projectDeployment'
  params: {
    // Required parameters
    devCenterResourceId: '<devCenterResourceId>'
    name: 'dcpmin001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "devCenterResourceId": {
      "value": "<devCenterResourceId>"
    },
    "name": {
      "value": "dcpmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/dev-center/project:<version>'

// Required parameters
param devCenterResourceId = '<devCenterResourceId>'
param name = 'dcpmin001'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module project 'br/public:avm/res/dev-center/project:<version>' = {
  name: 'projectDeployment'
  params: {
    // Required parameters
    devCenterResourceId: '<devCenterResourceId>'
    name: 'dcpmax001'
    // Non-required parameters
    catalogSettings: {
      catalogItemSyncTypes: [
        'EnvironmentDefinition'
        'ImageDefinition'
      ]
    }
    description: 'This is a test project for the Dev Center project module.'
    displayName: 'My Dev Center Project'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    maxDevBoxesPerUser: 2
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'DevCenter Project Admin'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "devCenterResourceId": {
      "value": "<devCenterResourceId>"
    },
    "name": {
      "value": "dcpmax001"
    },
    // Non-required parameters
    "catalogSettings": {
      "value": {
        "catalogItemSyncTypes": [
          "EnvironmentDefinition",
          "ImageDefinition"
        ]
      }
    },
    "description": {
      "value": "This is a test project for the Dev Center project module."
    },
    "displayName": {
      "value": "My Dev Center Project"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "maxDevBoxesPerUser": {
      "value": 2
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "DevCenter Project Admin"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/dev-center/project:<version>'

// Required parameters
param devCenterResourceId = '<devCenterResourceId>'
param name = 'dcpmax001'
// Non-required parameters
param catalogSettings = {
  catalogItemSyncTypes: [
    'EnvironmentDefinition'
    'ImageDefinition'
  ]
}
param description = 'This is a test project for the Dev Center project module.'
param displayName = 'My Dev Center Project'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param maxDevBoxesPerUser = 2
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'DevCenter Project Admin'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module project 'br/public:avm/res/dev-center/project:<version>' = {
  name: 'projectDeployment'
  params: {
    // Required parameters
    devCenterResourceId: '<devCenterResourceId>'
    name: 'dcpwaf001'
    // Non-required parameters
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    maxDevBoxesPerUser: 2
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "devCenterResourceId": {
      "value": "<devCenterResourceId>"
    },
    "name": {
      "value": "dcpwaf001"
    },
    // Non-required parameters
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "maxDevBoxesPerUser": {
      "value": 2
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/dev-center/project:<version>'

// Required parameters
param devCenterResourceId = '<devCenterResourceId>'
param name = 'dcpwaf001'
// Non-required parameters
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param maxDevBoxesPerUser = 2
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devCenterResourceId`](#parameter-devcenterresourceid) | string | Resource ID of an associated DevCenter. |
| [`name`](#parameter-name) | string | The name of the project. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`catalogSettings`](#parameter-catalogsettings) | object | The settings to be used when associating a project with a catalog. The Dev Center this project is associated with must allow configuring catalog item sync types before configuring project level catalog settings. |
| [`description`](#parameter-description) | string | The description of the project. |
| [`displayName`](#parameter-displayname) | string | The display name of project. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`maxDevBoxesPerUser`](#parameter-maxdevboxesperuser) | int | When specified, limits the maximum number of Dev Boxes a single user can create across all pools in the project. This will have no effect on existing Dev Boxes when reduced. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Resource tags to apply to the project. |

### Parameter: `devCenterResourceId`

Resource ID of an associated DevCenter.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the project.

- Required: Yes
- Type: string

### Parameter: `catalogSettings`

The settings to be used when associating a project with a catalog. The Dev Center this project is associated with must allow configuring catalog item sync types before configuring project level catalog settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`catalogItemSyncTypes`](#parameter-catalogsettingscatalogitemsynctypes) | array | Indicates catalog item types that can be synced. |

### Parameter: `catalogSettings.catalogItemSyncTypes`

Indicates catalog item types that can be synced.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'EnvironmentDefinition'
    'ImageDefinition'
  ]
  ```

### Parameter: `description`

The description of the project.

- Required: No
- Type: string

### Parameter: `displayName`

The display name of project.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `maxDevBoxesPerUser`

When specified, limits the maximum number of Dev Boxes a single user can create across all pools in the project. This will have no effect on existing Dev Boxes when reduced.

- Required: No
- Type: int
- MinValue: 0

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DevCenter Project Admin'`
  - `'DevCenter Dev Box User'`
  - `'DevTest Labs User'`
  - `'Deployment Environments User'`
  - `'Deployment Environments Reader'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `tags`

Resource tags to apply to the project.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the Dev Center Project resource was deployed into. |
| `name` | string | The name of the Dev Center Project. |
| `resourceGroupName` | string | The name of the resource group the Dev Center Project resource was deployed into. |
| `resourceId` | string | The resource ID of the Dev Center Project. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
