param aiSearchName string
param location string

resource aiSearch 'Microsoft.Search/searchServices@2025-02-01-Preview' = {
  name: aiSearchName
  location: location
  sku: {
    name: 'standard'
  }
  // 啟用 System Assigned Identity
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    partitionCount: 1
    replicaCount: 1
    hostingMode: 'default'
    // Supports both API keys and RBAC for authentication
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    // Disable local authentication to enforce RBAC
    disableLocalAuth: false
  }
}

output aiSearchPrincipalId string = aiSearch.identity.principalId
output aiSearchName string = aiSearch.name
output aiSearchId string = aiSearch.id
