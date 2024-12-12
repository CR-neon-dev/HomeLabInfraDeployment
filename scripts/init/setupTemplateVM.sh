#!/bin/bash

# Define the URL and the target directory
URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
TARGET_DIR="/"
FILE_NAME="debian-12-genericcloud-amd64.qcow2"

# Use wget to download the file to the target directory
wget -O "${TARGET_DIR}${FILE_NAME}" "$URL"

# Create a VM from the image
qm create 9000 --name debian12-cloudinit

# Import Cloud-Init Image 
qm set 9000 --scsi0 local-lvm:0,import-from=/root/debian-12-genericcloud-amd64.qcow2

# Create Template from VM
qm template 9000
