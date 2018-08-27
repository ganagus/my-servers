# my-servers
My servers infrastructure on Azure. This project is based on the following project: [poc-iaac-azure-linux-script](https://github.com/icgid/poc-iaac-azure-linux-script), with the following additional features:
* HTTPS probe and load balancing rule
* More proper Nginx+Wordpress configuration
* Configurable Wordpress domain name
* Configurable Wordpress database name
* Script to configure SSL site using [Letsencrypt](https://letsencrypt.org/)

This is the code that I use to deploy my servers on Azure that hosts the following sites:
* [aprojectguru.com](https://aprojectguru.com)
* [pena.id](https://pena.id)
* [renang.com](https://renang.com)

However, source code for all those sites are hosted in separate different private projects hosted on my VSTS.

### Deployment
First, create the resource group:

```
az group create --name "my-servers" --location southeastasia
```
Then, perform the deployment:
```
az group deployment create --name MyServersDeployment --resource-group "my-servers" --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
