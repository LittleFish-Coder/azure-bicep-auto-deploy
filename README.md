# Hackathon Bicep Templates for Azure Services

> you have to install [Azure CLI](https://learn.microsoft.com/zh-tw/cli/azure/install-azure-cli?view=azure-cli-latest) and [Bicep CLI](https://learn.microsoft.com/zh-tw/azure/azure-resource-manager/bicep/install) first

Before you start, make sure you have the Azure CLI and Bicep CLI installed on your machine.
```bash
az --version # check Azure CLI version
az bicep version # check Bicep CLI version
```
You should login and select your Azure subscription before deploying the templates.
```bash
az login # login to Azure
az account list --output table
az account set --subscription "Your Subscription Name" # select your Azure subscription
az account show --output table # check your current subscription
```


## Quick Setup
To quick deploy the Azure Bicep templates for the hackathon

0. (optional) Customize the parameters
1. Edit `users.txt` to include the user IDs of participants.
2. Run `createGroup.sh` to create a user group in Azure Active Directory.
3. Deploy the Bicep template using the Azure CLI.

### 0. (optional) Customize the parameters
- In `createGroup.sh` or `createGroup.ps1`, feel free to edit `display-name`, `mail-nickname`, `description` to customize the user group.
- In `00_hackathon.bicep`, you can customize the resources you want to deploy (line 3-11).


### 1. Edit `users.txt`
Put your user IDs in `users.txt`, one per line. 
```
user1-id@microsoft.com
user2-id@microsoft.com
...
```

### 2. Run `createGroup.sh`
Run the script and get the `GROUP_ID`.
```bash
bash createGroup.sh # Linux / Mac
.\createGroup.ps1 # Windows PowerShell
```

### 3. Deploy the Bicep Template
Replace the `GROUP_ID` in `00_hackathon.bicep` with the one you got from the previous step.
```bash
param userGroupID string = 'GROUP_ID' # Replace with your user group ID
```

Then run the following command to deploy the Bicep template:
```bash
az deployment sub create --location eastUS --template-file 00_hackathon.bicep
```
(This would take 10-15 minutes)
You can check the deployment status in the Azure Portal under "Resource groups -> deployments".
If no errors occur, then the process is complete and you can start using the resources.

## Reference

- search userID / groupID
(replace your email address correctly)
```bash
az ad user list --filter "mail eq 'username@email.com'" --query "[].id" -o tsv
```

- search roleName object id (check [built-in-roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles))
```bash
az role definition list --query "[?roleName=='Search Service Contributor'].{Name:roleName, ID:name}" -o table
```
### Other Document

[Microsoft Learn - Bicep](https://learn.microsoft.com/zh-tw/azure/azure-resource-manager/bicep/overview)

[Official Example](https://learn.microsoft.com/zh-tw/azure/azure-resource-manager/bicep/quickstart-create-bicep-use-visual-studio-code)

[AI Foundry Documentation](https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/create-resource-template)