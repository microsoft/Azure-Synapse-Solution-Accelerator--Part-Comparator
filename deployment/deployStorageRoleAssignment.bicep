// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

param synapseIdentity string
param synapseName string
param userObjectID string

resource synapse 'Microsoft.Synapse/workspaces@2021-03-01' existing = {
  name: synapseName
}

var roleIDStorageBlobDataContributor = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
var storageRoleID_sp = guid('storagerolesp-${uniqueString(resourceGroup().name)}')
var storageRoleID_user = guid('storageroleuser-${resourceGroup().name}')


resource assignStorageBlobDataContributor_sp 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: storageRoleID_sp
  dependsOn:[
     synapse
  ]

  properties:{
    principalId: synapseIdentity
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions',roleIDStorageBlobDataContributor)
    principalType:'ServicePrincipal'
  }
 }

 resource assignStorageBlobDataContributor_user 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: storageRoleID_user
  dependsOn:[
     synapse
  ]

  properties:{
    principalId: userObjectID
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions',roleIDStorageBlobDataContributor)
    principalType:'User'
  }
 }

