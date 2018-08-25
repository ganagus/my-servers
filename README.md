# my-servers
My servers infrastructure on Azure.
### Deployment
First, create the resource group:

```
az group create --name "my-servers" --location southeastasia
```
Then, perform the deployment:
```
az group deployment create --name MyServersDeployment --resource-group "my-servers" --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
