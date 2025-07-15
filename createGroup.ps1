# Create a new Azure AD group and add users from a file
$GROUP_ID = az ad group create `
    --display-name "TrendMicro Hackathon Group" `
    --mail-nickname "trend-micro-hackathon-group" `
    --description "Hackathon participants" `
    --query id -o tsv

Write-Host "Created group with ID: $GROUP_ID"

# Read users from users.txt and add them to the group
Get-Content "users.txt" | ForEach-Object {
    $email = $_.Trim()
    Write-Host "Processing: $email"
    
    if ($email -ne "") {
        $USER_ID = az ad user list --filter "mail eq '$email'" --query "[].id" -o tsv
        Write-Host "User ID: $USER_ID"
        
        if ($USER_ID) {
            az ad group member add --group "$GROUP_ID" --member-id "$USER_ID"
            Write-Host "Added: $email"
        } else {
            Write-Host "User not found: $email"
        }
    }
}

Write-Host "Group ID: $GROUP_ID"
