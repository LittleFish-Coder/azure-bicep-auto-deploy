# Script to read users.txt and get user IDs by email addresses
# Output format: array of user IDs for use in Bicep templates

Write-Host "Reading users from users.txt and looking up user IDs..."

$USER_IDS = @()

# Read users from users.txt and get their IDs
Get-Content "users.txt" | ForEach-Object {
    $email = $_.Trim()
    
    if ($email -ne "") {
        Write-Host "Processing: $email"
        
        $USER_ID = az ad user list --filter "mail eq '$email'" --query "[].id" -o tsv
        
        if ($USER_ID) {
            $USER_IDS += $USER_ID
            Write-Host "Found user ID: $USER_ID for $email"
        } else {
            Write-Host "Warning: User not found: $email"
        }
    }
}

# Output the user IDs
if ($USER_IDS.Count -eq 0) {
    Write-Host "Error: No valid user IDs found"
    exit 1
}

Write-Host ""
Write-Host "Found $($USER_IDS.Count) user(s)"
Write-Host "User IDs (comma-separated): $($USER_IDS -join ',')"

# Output as JSON array for parameter file
Write-Host ""
Write-Host "For parameters file (userIds parameter):"
$jsonArray = '["' + ($USER_IDS -join '","') + '"]'
Write-Host $jsonArray