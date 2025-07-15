param storageAccountName string
param location string
// param aiSearchPrincipalId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    // supportsHttpsTrafficOnly: true
    // minimumTlsVersion: 'TLS1_2'
  }
}

// Assign "Storage Blob Data Reader" role to AI Search service
// param roleDefinitionId string = '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1' // Storage Blob Data Reader role ID
// var roleAssignmentName= guid(aiSearchPrincipalId, roleDefinitionId, resourceGroup().id)
// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: roleAssignmentName
//   scope: storageAccount
//   properties: {
//     roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
//     principalId: aiSearchPrincipalId
//   }
// }

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
