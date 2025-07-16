# Hackathon Bicep Templates for Azure Services

> You have to install [Azure CLI](https://learn.microsoft.com/zh-tw/cli/azure/install-azure-cli?view=azure-cli-latest) and [Bicep CLI](https://learn.microsoft.com/zh-tw/azure/azure-resource-manager/bicep/install) first

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

1. Edit `users.txt` to include the email addresses of participants.
2. Run `getUserIds.sh` (or `getUserIds.ps1`) to get user IDs from email addresses.
3. Deploy the Bicep template using the Azure CLI with the user IDs.

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
You will get a file named `user_ids.txt` with user IDs, one per line.
```bash
user-id-1
user-id-2
...
```

### 3. Deploy the Bicep Template
You can deploy using one of these methods:

#### 3.1 **Method A: VS Code extension manual deployment (recommended)**
> Must first download the [Bicep extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) for Visual Studio Code.
1. Modify `team` and `userIds` in `00_hackathon.bicep` file
2. Right-click on the `00_hackathon.bicep` file in VS Code and select "Deploy Bicep file..."
```
# You might go through a few prompts to deploy the Bicep template.
1. Name your deployment (e.g., "Hackathon Deployment")
2. Select the subscription
3. Select the location (e.g., "East US")
4. Select a parameter file (choose None)
```

#### 3.2 **Method B: Deploy via Azure CLI after Editing Bicep File**
1. Modify `team` and `userIds` in `00_hackathon.bicep` file
2. Deploy the Bicep template using the Azure CLI:
  ```bash
  az deployment sub create --location eastUS --template-file 00_hackathon.bicep
  ```

#### 3.3 **Method C: With inline parameters**
```bash
az deployment sub create --location eastUS --template-file 00_hackathon.bicep --parameters team='team_id' userIds='["user-id-1","user-id-2"]'
```

#### Deployment Process
The deployment will take about 10-15 minutes to complete, depending on the resources being created. You can check the deployment status in the Azure Portal under `Resource groups -> deployments`. If no errors occur, then the process is complete and you can start using the resources.

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