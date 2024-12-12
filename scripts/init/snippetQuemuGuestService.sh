#!/bin/bash
# Define the directory and file path
DIRECTORY="/var/lib/vz/snippets"
FILE="$DIRECTORY/qemu-guest-agent.yml"

# Create the directory if it doesn't exist
if [ ! -d "$DIRECTORY" ]; then
  echo "Directory $DIRECTORY does not exist. Creating it now."
  mkdir -p "$DIRECTORY"
else
  echo "Directory $DIRECTORY already exists."
fi

# Create or replace the file
echo "Creating or replacing $FILE."

cat <<EOL > "$FILE"
# Contents of qemu-guest-agent.yml
# Add your Cloud-Init configuration here

runcmd:
  - apt update
  - apt install -y qemu-guest-agent
  - systemctl start qemu-guest-agent


EOL

echo "File $FILE has been created or replaced."

# Confirm completion
echo "Script execution completed."
