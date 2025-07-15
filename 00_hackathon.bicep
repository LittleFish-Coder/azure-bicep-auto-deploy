targetScope = 'subscription'

param team string = '00'
param userGroupID string = 'GROUP_ID' // Replace with your user group ID
param resourceGroupName string = 'rg-hackathon-team${team}'
param aiFoundryName string = 'ai-foundry-hackathon-team${team}'
param aiProjectName string = 'ai-project-hackathon-team${team}'
param aiSearchName string = 'ai-search-hackathon-team${team}'
param openAIName string = 'openai-hackathon-team${team}'
param storageAccountName string = 'storagehackathonteam${team}'
param location string = 'eastus'


// 00_Create a resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: location
}

// 01_Create an AI Foundry resource
module aiFoundryModule '01_aiFoundry.bicep' = {
  name: 'aiFoundryModule'
  scope: resourceGroup
  params: {
    aiFoundryName: aiFoundryName
    aiProjectName: aiProjectName
    location: location
  }
}

// 02_Create an AI search resource
module aiSearchModule '02_aiSearch.bicep' = {
  name: 'aiSearchModule'
  scope: resourceGroup
  params: {
    aiSearchName: aiSearchName
    location: location
  }
}


// 03_Create a storage account
module storageModule '03_storage.bicep' = {
  name: 'storageModule'
  scope: resourceGroup
  params: {
    storageAccountName: storageAccountName
    location: location
  }
}

// 04_Create an Azure OpenAI resource
module openAIModule '04_openAI.bicep' = {
  name: 'openAIModule'
  scope: resourceGroup
  params: {
    openAIName: openAIName
    location: location
  }
}

// 05 role assignment for the user group
module rbacModule '05_rbac.bicep' = {
  name: 'rbacModule'
  scope: resourceGroup
  params: {
    userGroupID: userGroupID
    aiSearchPrincipalId: aiSearchModule.outputs.aiSearchPrincipalId
  }
  dependsOn: [
    aiFoundryModule
    storageModule
    openAIModule
  ]
}
