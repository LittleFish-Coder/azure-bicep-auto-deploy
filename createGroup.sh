# Create a new Azure AD group and add users from a file
GROUP_ID=$(az ad group create \
    --display-name "TrendMicro Hackathon Group" \
    --mail-nickname "trend-micro-hackathon-group" \
    --description "Hackathon participants" \
    --query id -o tsv)


echo "Created group with ID: $GROUP_ID"

# Read users from users.txt and add them to the group
while IFS= read -r line; do

    email=$(echo "$line" | tr -d '\r\n\t ' | xargs)
    echo "Processing: $email"

    # filter=$(printf "mail eq '%s'" "$email")
    # echo "Filter: $filter"
    # USER_ID=$(az ad user list --filter "$filter" --query "[].id" -o tsv)
    
    USER_ID=$(az ad user list --filter "mail eq '$email'" --query "[].id" -o tsv)
    echo "User ID: $USER_ID"
    
    if [ ! -z "$USER_ID" ]; then
        az ad group member add --group "$GROUP_ID" --member-id "$USER_ID"
        echo "Added: $email"
    else
        echo "User not found: $email"
    fi
    
done < users.txt

echo "Group ID: $GROUP_ID"