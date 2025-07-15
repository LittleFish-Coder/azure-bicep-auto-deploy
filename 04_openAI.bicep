param openAIName string
param location string
// param aiSearchPrincipalIdId string

resource openAIService 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: openAIName
  location: location
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    customSubDomainName: openAIName
    publicNetworkAccess: 'Enabled'
  }
}

// Assign "Cognitive Services OpenAI User" role to AI Search service
// param roleDefinitionId string = '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd' // Cognitive Services OpenAI User role ID
// var roleAssignmentName= guid(aiSearchPrincipalIdId, roleDefinitionId, resourceGroup().id)
// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: roleAssignmentName
//   scope: openAIService
//   properties: {
//     roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
//     principalId: aiSearchPrincipalIdId
//   }
// }

output openAIId string = openAIService.id
output openAIEndpoint string = openAIService.properties.endpoint
