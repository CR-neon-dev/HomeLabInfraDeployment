#!/bin/bash

# Check if libguestfs-tools is installed
if ! dpkg -l | grep -q libguestfs-tools; then
    echo "libguestfs-tools not found. Installing..."
    sudo apt update -y
    sudo apt install libguestfs-tools -y
else
    echo "libguestfs-tools is already installed."
    sudo apt update -y
fi

# Download Debian 12 Cloud-Init image 
sudo wget -P /root/ https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

# Run virt-customize on the downloaded image 
IMAGE_PATH="/root/jammy-server-cloudimg-amd64.img" 

# Run virt-customize on the downloaded image 
sudo virt-customize -a $IMAGE_PATH --install qemu-guest-agent

# Create a VM from the image
qm create 9000 --name ubuntu-cloudinit

# Import Cloud-Init Image 
qm set 9000 --scsi0 local-lvm:0,import-from=/root/jammy-server-cloudimg-amd64.img

# Create Template from VM
# qm template 9000
