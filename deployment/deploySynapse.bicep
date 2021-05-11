// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

param adlsStorageAccountURL string
param adlsFileSystem string
@secure()
param sqlAdminLoginPassword string
param sqlAdminLoginId string

resource synapseComparator 'Microsoft.Synapse/workspaces@2021-03-01' = {
  name: 'partcomparatorws-${uniqueString(resourceGroup().id)}'
  tags: {}
  location: resourceGroup().location
  identity: {
    type:'SystemAssigned'
  }
  properties: {
      defaultDataLakeStorage: {
        accountUrl: adlsStorageAccountURL
        filesystem: adlsFileSystem
      }
      virtualNetworkProfile:{
        computeSubnetId: ''
      }
      sqlAdministratorLoginPassword: sqlAdminLoginPassword
      sqlAdministratorLogin: sqlAdminLoginId
  }
}

resource synapseFirewallRules 'Microsoft.Synapse/workspaces/firewallRules@2021-03-01' = {
  name: '${synapseComparator.name}/partcomparatorws-firewall'

  dependsOn:[
    synapseComparator
  ]

  properties:{
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
  
}

resource synapsePool 'Microsoft.Synapse/workspaces/bigDataPools@2021-03-01' = {
  name : 'sparkpool1'
  location: resourceGroup().location
  parent: synapseComparator
  dependsOn:[
    synapseComparator
  ]
  properties:{
    sparkVersion: '2.4'
    nodeCount: 3
    nodeSize: 'Large'
    nodeSizeFamily:'MemoryOptimized'
    autoScale:{
      enabled: true
      minNodeCount: 3
      maxNodeCount: 15
    }
    autoPause:{
      enabled: true
      delayInMinutes: 15
    }
    dynamicExecutorAllocation:{
      enabled: true
    }
    provisioningState: 'Succeeded'
  }
}

output identity string = synapseComparator.identity.principalId
output synapseWorkspaceName string = synapseComparator.name
