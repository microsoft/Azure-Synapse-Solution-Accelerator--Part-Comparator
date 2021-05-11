# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

param(
    [Parameter(Mandatory= $True,
                HelpMessage='Write your subscription ID to deploy your resources')]
    [string]
    $subscriptionID = '',
    [Parameter(Mandatory= $True,
                HelpMessage='Write Azure Data Center to deploy your resources')]
    [string]
    $location = '',
    [Parameter(Mandatory= $True,
                HelpMessage='Put the SQL Password for your SQL Pool instance')]
    [securestring]
    $sqlpassword = ''
)

Write-Host "Login Azure.....`r`n"

az login
Write-Host "Select subscription '$subscriptionID'"
az account set --subscription $subscriptionID
Write-Host "Switched subscription to '$subscriptionID'"

$userObjectID = az ad signed-in-user show --query objectId -o tsv
Write-Host "This is userobject ID "$userObjectID

#$deploymentResult = az deployment sub create -f .\main.bicep -l $location -n 'partcomparatorsa' -p userObjectID=$userObjectID
$deploymentResult = az deployment sub create --template-file .\azuredeploy.json -l $location -n 'partcomparatorsa' -p userObjectID=$userObjectID sqlPassword=$sqlpassword
$joinedString = $deploymentResult -join "" 
$jsonString = ConvertFrom-Json $joinedString

$resourceGroupName = $jsonString.properties.outputs.resourcegroupName.value
$storageAccountName = $jsonString.properties.outputs.storageAccountName.value
$synapseWorkspaceName = $jsonString.properties.outputs.synapseworkspaceName.value

Write-Host "Resource Deployment has been completed"
Write-Host "Upload Dataset in Azure Data Lake source filesystem in $storageAccountName"
$storageAccountKey = az storage account keys list -g $resourceGroupName -n $storageAccountName --query "[?keyName == 'key1'].value" -o tsv
az storage blob upload-batch -d sources --account-key $storageAccountKey --account-name $storageAccountName -s '..\data'

# Write-Host "Uploading Notebooks to Synapse Workspace($synapseWorkspaceName)"

# az synapse notebook import --workspace-name $synapseWorkspaceName --name DataPreparation --file '..\src\notebooks\Comparator - Data Preparation.ipynb'
# az synapse notebook import --workspace-name $synapseWorkspaceName --name DataModeling --file '..\src\notebooks\Comparator - Modeling.ipynb'

Write-Host "Whole Deployment process has been done"