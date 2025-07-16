targetScope = 'resourceGroup'

param userIds array
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


// Note: Owner role assignment is commented out as it may be too broad for regular users
// Uncomment and modify if owner permissions are specifically needed:
// resource userOwnerRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (userId, index) in userIds: {
//   name: guid(resourceGroup().id, userId, 'Owner')
//   properties: {
//     roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.userGroupOwner)
//     principalId: userId
//   }
// }]

// Assign roles to individual users
resource userContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (userId, index) in userIds: {
  name: guid(resourceGroup().id, userId, 'Contributor')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.userGroupContributor)
    principalId: userId
  }
}]

// Assign AI Search roles to individual users
resource aiSearchServiceContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (userId, index) in userIds: {
  name: guid(resourceGroup().id, userId, 'SearchServiceContributor')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.searchServiceContributor)
    principalId: userId
  }
}]

resource aiSearchIndexDataContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (userId, index) in userIds: {
  name: guid(resourceGroup().id, userId, 'SearchIndexDataContributor')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.searchIndexDataContributor)
    principalId: userId
  }
}]

resource aiSearchIndexDataReaderRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (userId, index) in userIds: {
  name: guid(resourceGroup().id, userId, 'SearchIndexDataReader')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.searchIndexDataReader)
    principalId: userId
  }
}]

// Assign Storage roles to individual users
resource storageBlobDataReaderRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (userId, index) in userIds: {
  name: guid(resourceGroup().id, userId, 'StorageBlobDataReader')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.storageBlobDataReader)
    principalId: userId
  }
}]
// Output the role assignment IDs
output storageBlobDataReaderAISearchRoleId string = storageBlobDataReaderAISearchRole.id
output cognitiveServicesOpenAIUserAISearchRoleId string = cognitiveServicesOpenAIUserAISearchRole.id
// Output arrays of role assignment IDs for user roles
output userContributorRoleIds array = [for (userId, index) in userIds: userContributorRole[index].id]
output aiSearchServiceContributorRoleIds array = [for (userId, index) in userIds: aiSearchServiceContributorRole[index].id]
output aiSearchIndexDataContributorRoleIds array = [for (userId, index) in userIds: aiSearchIndexDataContributorRole[index].id]
output aiSearchIndexDataReaderRoleIds array = [for (userId, index) in userIds: aiSearchIndexDataReaderRole[index].id]
output storageBlobDataReaderRoleIds array = [for (userId, index) in userIds: storageBlobDataReaderRole[index].id]
