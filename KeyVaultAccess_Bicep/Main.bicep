param logStartMinsAgo int = 50
param now string = utcNow('F')

var keyvaultName = toLower('KeyVault${uniqueString(resourceGroup().id)}')
var keyvaultTenantId = subscription().tenantId
var getDeployObjectIDScript = loadTextContent('./scripts/getDeployObjectID.ps1')
var sshKeyGenScript = loadTextContent('./scripts/sshKeyGen.sh')

//Create User Defined Identity

resource UAIKVAdmin 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: '${resourceGroup().name}-UAIKVAdmin'
    location: resourceGroup().location
}

// Assign previously assigned identity the contributor role in the current context

var roleDefinitionId2 = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
var roleAssignmentName_var2 = guid(subscription().id, UAIKVAdmin.id, roleDefinitionId2)

resource UAIRoleContributors 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleAssignmentName_var2
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId2)
    principalId: UAIKVAdmin.properties.principalId
    principalType: 'ServicePrincipal'
  }
  dependsOn: [
    UAIKVAdmin
  ]
}

//create a key vault with RBAC access policy enabled

resource keyvault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: keyvaultName
  location: resourceGroup().location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
    enableSoftDelete: false
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: keyvaultTenantId
  }
}

// execute a PowerShell script that will search the Azure Activity log for the userid of the entity that create the Keyvault
// the script uses the user defined identitiy to access the log info

resource deploymentUser 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'getDeploymentUser'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${UAIKVAdmin.id}': {}
    }
  }
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '6.2.1'
    arguments: ' -ResourceGroupName ${resourceGroup().name} -DeploymentName ${deployment().name} -StartTime ${logStartMinsAgo}'
    scriptContent: getDeployObjectIDScript
    forceUpdateTag: now
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
    timeout: 'PT${logStartMinsAgo}M'
  }
  dependsOn: [
    UAIKVAdmin
    UAIRoleContributors
    keyvault
  ]
}

// set deployment entity as Key Vault Secrets User

var KVroleDefinitionId = '4633458b-17de-408a-b874-0445c86b69e6'
var KVroleDefinitiontName = guid(subscription().id, deploymentUser.id, KVroleDefinitionId)

resource KVRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: KVroleDefinitiontName
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', KVroleDefinitionId)
    principalId: deploymentUser.properties.outputs.userAccount
    principalType: 'User'
  }
  dependsOn: [
    deploymentUser
  ]
}

output userAccount string = deploymentUser.properties.outputs.userAccount
