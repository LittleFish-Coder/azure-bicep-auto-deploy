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
1. Edit `users.txt` to include the email addresses of participants.
2. Run `getUserIds.sh` (or `getUserIds.ps1`) to get user IDs from email addresses.
3. Deploy the Bicep template using the Azure CLI with the user IDs.

### 0. (optional) Customize the parameters
- In `00_hackathon.bicep`, you can customize the resources you want to deploy (line 3-11).


### 1. Edit `users.txt`
Put your user email addresses in `users.txt`, one per line. 
```
user1@microsoft.com
user2@microsoft.com
...
```

### 2. Run `getUserIds.sh` to get user IDs
Run the script to get user IDs from email addresses:
```bash
bash getUserIds.sh # Linux / Mac
.\getUserIds.ps1 # Windows PowerShell
```

This will output the user IDs in a format suitable for the Bicep template parameters.

### 3. Deploy the Bicep Template
You can deploy using one of these methods:

**Method A: With inline parameters**
```bash
az deployment sub create \
  --location eastUS \
  --template-file 00_hackathon.bicep \
  --parameters userIds='["user-id-1","user-id-2","user-id-3"]'
```

**Method B: With parameters file**
1. Copy the user IDs from step 2 into `parameters.json` file
2. Deploy with parameters file:
```bash
az deployment sub create \
  --location eastUS \
  --template-file 00_hackathon.bicep \
  --parameters @parameters.json
```
(This would take 10-15 minutes)
You can check the deployment status in the Azure Portal under "Resource groups -> deployments".
If no errors occur, then the process is complete and you can start using the resources.

## Legacy Group-based Deployment (Alternative)
If you prefer to use the previous group-based approach, you can still use the `createGroup.sh` script:

1. Run `createGroup.sh` to create a user group and get the GROUP_ID
2. Create a custom parameters file with the group ID:
```json
{
  "userIds": {
    "value": ["YOUR_GROUP_ID_HERE"]
  }
}
```
3. Deploy using the parameters file

Note: The new individual user approach is recommended as it provides more granular control over permissions.

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