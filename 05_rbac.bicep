targetScope = 'resourceGroup'

param userGroupID string
param aiSearchPrincipalId string

// check https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
var roleDefinitions = {
  // Priviledge for the user group to manage the resource group
  userGroupOwner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  userGroupContributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'

  // AI Search roles
  searchServiceContributor: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
  searchIndexDataContributor: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
  searchIndexDataReader: '1407120a-92aa-4202-b7e9-c0e197c71c8f'

  // Storage roles
  storageBlobDataReader: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'

  // Cognitive Services roles
  cognitiveServicesOpenAIUser: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
  
}

// Assign roles to the user group
// resource userGroupOwnerRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(resourceGroup().id, userGroupID, 'Owner')
//   properties: {
//     roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.userGroupOwner)
//     principalId: userGroupID
//   }
// }


// Assign "Storage Blob Data Reader" role to AI Search service
resource storageBlobDataReaderAISearchRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, aiSearchPrincipalId, 'StorageBlobDataReader')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.storageBlobDataReader)
    principalId: aiSearchPrincipalId
  }
}

// Assign "Cognitive Services OpenAI User" role to AI Search service
resource cognitiveServicesOpenAIUserAISearchRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, aiSearchPrincipalId, roleDefinitions.cognitiveServicesOpenAIUser)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.cognitiveServicesOpenAIUser)
    principalId: aiSearchPrincipalId
  }
}


resource userGroupContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userGroupID, 'Contributor')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.userGroupContributor)
    principalId: userGroupID
  }
}

// Assign AI Search roles to the user group
resource aiSearchServiceContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userGroupID, 'SearchServiceContributor')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.searchServiceContributor)
    principalId: userGroupID
  }
}

resource aiSearchIndexDataContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userGroupID, 'SearchIndexDataContributor')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.searchIndexDataContributor)
    principalId: userGroupID
  }
}

resource aiSearchIndexDataReaderRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userGroupID, 'SearchIndexDataReader')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.searchIndexDataReader)
    principalId: userGroupID
  }
}

// Assign Storage roles to the user group
resource storageBlobDataReaderRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userGroupID, 'StorageBlobDataReader')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.storageBlobDataReader)
    principalId: userGroupID
  }
}
// Output the role assignment IDs
output storageBlobDataReaderAISearchRoleId string = storageBlobDataReaderAISearchRole.id
output cognitiveServicesOpenAIUserAISearchRoleId string = cognitiveServicesOpenAIUserAISearchRole.id
// output userGroupOwnerRoleId string = userGroupOwnerRole.id
output userGroupContributorRoleId string = userGroupContributorRole.id
output aiSearchServiceContributorRoleId string = aiSearchServiceContributorRole.id
output aiSearchIndexDataContributorRoleId string = aiSearchIndexDataContributorRole.id
output aiSearchIndexDataReaderRoleId string = aiSearchIndexDataReaderRole.id
output storageBlobDataReaderRoleId string = storageBlobDataReaderRole.id
