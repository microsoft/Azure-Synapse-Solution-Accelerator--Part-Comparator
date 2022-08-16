# Privacy

When you deploy this template, Microsoft is able to identify the installation of the software with the Azure resources that are deployed. Microsoft is able to correlate the Azure resources that are used to support the software. Microsoft collects this information to provide the best experiences with their products and to operate their business. The data is collected and governed by Microsoft's privacy policies, which can be found at [Microsoft Privacy Statement](https://go.microsoft.com/fwlink/?LinkID=824704).

To disable this, simply remove the following section from [azuredeploy.json](./deployment/azuredeploy.json) before deploying the resources to Azure:

```json
    {
      "type": "Microsoft.Resources/deployments",
      "apiVersion": "2019-10-01",
      "name": "pid-740ba6b5-168a-5abb-8df4-ff0de6a9d5ee",
      "resourceGroup": "[format('partcomparator-{0}', parameters('resourceprefix'))]",
      "properties": {
        "expressionEvaluationOptions": {
          "scope": "inner"
        },
        "mode": "Incremental",
        "parameters": {},
        "template": {
          "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
          "contentVersion": "1.0.0.0",
          "metadata": {
            "_generator": {
              "name": "bicep",
              "version": "0.3.255.40792",
              "templateHash": "16652949447310441715"
            }
          },
          "functions": [],
          "resources": []
        }
      }
```

You can see more information on this at https://docs.microsoft.com/en-us/azure/marketplace/azure-partner-customer-usage-attribution.
