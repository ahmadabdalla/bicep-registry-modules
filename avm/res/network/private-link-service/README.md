# Private Link Services `[Microsoft.Network/privateLinkServices]`

This module deploys a Private Link Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/privateLinkServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateLinkServices) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/private-link-service:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkService 'br/public:avm/res/network/private-link-service:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-nplsmin'
  params: {
    // Required parameters
    name: 'nplsmin001'
    // Non-required parameters
    ipConfigurations: [
      {
        name: 'nplsmin01'
        properties: {
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: '<id>'
      }
    ]
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nplsmin001"
    },
    // Non-required parameters
    "ipConfigurations": {
      "value": [
        {
          "name": "nplsmin01",
          "properties": {
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "loadBalancerFrontendIpConfigurations": {
      "value": [
        {
          "id": "<id>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkService 'br/public:avm/res/network/private-link-service:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-nplsmax'
  params: {
    // Required parameters
    name: 'nplsmax001'
    // Non-required parameters
    autoApproval: {
      subscriptions: [
        '*'
      ]
    }
    enableProxyProtocol: true
    fqdns: [
      'nplsmax.plsfqdn01.azure.privatelinkservice'
      'nplsmax.plsfqdn02.azure.privatelinkservice'
    ]
    ipConfigurations: [
      {
        name: 'nplsmax01'
        properties: {
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: '<id>'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    visibility: {
      subscriptions: [
        '<subscriptionId>'
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nplsmax001"
    },
    // Non-required parameters
    "autoApproval": {
      "value": {
        "subscriptions": [
          "*"
        ]
      }
    },
    "enableProxyProtocol": {
      "value": true
    },
    "fqdns": {
      "value": [
        "nplsmax.plsfqdn01.azure.privatelinkservice",
        "nplsmax.plsfqdn02.azure.privatelinkservice"
      ]
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "nplsmax01",
          "properties": {
            "primary": true,
            "privateIPAllocationMethod": "Dynamic",
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "loadBalancerFrontendIpConfigurations": {
      "value": [
        {
          "id": "<id>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "visibility": {
      "value": {
        "subscriptions": [
          "<subscriptionId>"
        ]
      }
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkService 'br/public:avm/res/network/private-link-service:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-nplswaf'
  params: {
    // Required parameters
    name: 'nplswaf001'
    // Non-required parameters
    autoApproval: {
      subscriptions: [
        '*'
      ]
    }
    enableProxyProtocol: true
    fqdns: [
      'nplswaf.plsfqdn01.azure.privatelinkservice'
      'nplswaf.plsfqdn02.azure.privatelinkservice'
    ]
    ipConfigurations: [
      {
        name: 'nplswaf01'
        properties: {
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: '<id>'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    visibility: {
      subscriptions: [
        '<subscriptionId>'
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nplswaf001"
    },
    // Non-required parameters
    "autoApproval": {
      "value": {
        "subscriptions": [
          "*"
        ]
      }
    },
    "enableProxyProtocol": {
      "value": true
    },
    "fqdns": {
      "value": [
        "nplswaf.plsfqdn01.azure.privatelinkservice",
        "nplswaf.plsfqdn02.azure.privatelinkservice"
      ]
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "nplswaf01",
          "properties": {
            "primary": true,
            "privateIPAllocationMethod": "Dynamic",
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "loadBalancerFrontendIpConfigurations": {
      "value": [
        {
          "id": "<id>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "visibility": {
      "value": {
        "subscriptions": [
          "<subscriptionId>"
        ]
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the private link service to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoApproval`](#parameter-autoapproval) | object | The auto-approval list of the private link service. |
| [`enableProxyProtocol`](#parameter-enableproxyprotocol) | bool | Lets the service provider use tcp proxy v2 to retrieve connection information about the service consumer. Service Provider is responsible for setting up receiver configs to be able to parse the proxy protocol v2 header. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`extendedLocation`](#parameter-extendedlocation) | object | The extended location of the load balancer. |
| [`fqdns`](#parameter-fqdns) | array | The list of Fqdn. |
| [`ipConfigurations`](#parameter-ipconfigurations) | array | An array of private link service IP configurations. |
| [`loadBalancerFrontendIpConfigurations`](#parameter-loadbalancerfrontendipconfigurations) | array | An array of references to the load balancer IP configurations. The Private Link service is tied to the frontend IP address of a Standard Load Balancer. All traffic destined for the service will reach the frontend of the SLB. You can configure SLB rules to direct this traffic to appropriate backend pools where your applications are running. Load balancer frontend IP configurations are different than NAT IP configurations. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags to be applied on all resources/resource groups in this deployment. |
| [`visibility`](#parameter-visibility) | object | Controls the exposure settings for your Private Link service. Service providers can choose to limit the exposure to their service to subscriptions with Azure role-based access control (Azure RBAC) permissions, a restricted set of subscriptions, or all Azure subscriptions. |

### Parameter: `name`

Name of the private link service to create.

- Required: Yes
- Type: string

### Parameter: `autoApproval`

The auto-approval list of the private link service.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `enableProxyProtocol`

Lets the service provider use tcp proxy v2 to retrieve connection information about the service consumer. Service Provider is responsible for setting up receiver configs to be able to parse the proxy protocol v2 header.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `extendedLocation`

The extended location of the load balancer.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `fqdns`

The list of Fqdn.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `ipConfigurations`

An array of private link service IP configurations.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `loadBalancerFrontendIpConfigurations`

An array of references to the load balancer IP configurations. The Private Link service is tied to the frontend IP address of a Standard Load Balancer. All traffic destined for the service will reach the frontend of the SLB. You can configure SLB rules to direct this traffic to appropriate backend pools where your applications are running. Load balancer frontend IP configurations are different than NAT IP configurations.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `visibility`

Controls the exposure settings for your Private Link service. Service providers can choose to limit the exposure to their service to subscriptions with Azure role-based access control (Azure RBAC) permissions, a restricted set of subscriptions, or all Azure subscriptions.

- Required: No
- Type: object
- Default: `{}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the private link service. |
| `resourceGroupName` | string | The resource group the private link service was deployed into. |
| `resourceId` | string | The resource ID of the private link service. |

## Cross-referenced modules

_None_