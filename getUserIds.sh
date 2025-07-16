#!/bin/bash

# Script to read users.txt and get user IDs by email addresses
# Output format: user IDs written one per line for use in Bicep templates

echo "Reading users from users.txt and looking up user IDs..."
echo ""

USER_IDS=()

# Read users from users.txt and get their IDs
while IFS= read -r line; do
    email=$(echo "$line" | tr -d '\r\n\t ' | xargs)
    
    if [ ! -z "$email" ]; then
        echo "Processing: $email"
        
        USER_ID=$(az ad user list --filter "mail eq '$email'" --query "[].id" -o tsv)
        
        if [ ! -z "$USER_ID" ]; then
            USER_IDS+=("$USER_ID")
            echo "Found user ID: $USER_ID for $email"
        else
            echo "Warning: User not found: $email"
        fi
        echo ""
    fi
    
done < users.txt

# Output the user IDs in a format suitable for Bicep
if [ ${#USER_IDS[@]} -eq 0 ]; then
    echo "Error: No valid user IDs found"
    exit 1
fi

echo "Found ${#USER_IDS[@]} user(s)"
echo "User IDs (comma-separated): $(IFS=','; echo "${USER_IDS[*]}")"

# Write user IDs to user_ids.txt (one per line)
printf '%s\n' "${USER_IDS[@]}" > user_ids.txt
echo "User IDs written to user_ids.txt"