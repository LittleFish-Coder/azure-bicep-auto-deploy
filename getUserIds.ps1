# Script to read users.txt and get user IDs by email addresses
# Output format: user IDs written one per line for use in Bicep templates

Write-Host "Reading users from users.txt and looking up user IDs..."
Write-Host ""

$USER_IDS = @()

# Read users from users.txt and get their IDs
Get-Content "users.txt" | ForEach-Object {
    $email = $_.Trim() -replace '\r|\n|\t', ''
    
    if ($email -ne "") {
        Write-Host "Processing: $email"
        
        $USER_ID = az ad user list --filter "mail eq '$email'" --query "[].id" -o tsv
        
        if ($USER_ID -and $USER_ID.Trim() -ne "") {
            $USER_IDS += $USER_ID.Trim()
            Write-Host "Found user ID: $($USER_ID.Trim()) for $email"
        } else {
            Write-Host "Warning: User not found: $email"
        }
        Write-Host ""
    }
}

# Output the user IDs in a format suitable for Bicep
if ($USER_IDS.Count -eq 0) {
    Write-Host "Error: No valid user IDs found"
    exit 1
}

Write-Host "Found $($USER_IDS.Count) user(s)"
Write-Host "User IDs (comma-separated): $($USER_IDS -join ',')"

# Write user IDs to user_ids.txt (one per line)
$USER_IDS | Out-File -FilePath "user_ids.txt" -Encoding UTF8
Write-Host "User IDs written to user_ids.txt"