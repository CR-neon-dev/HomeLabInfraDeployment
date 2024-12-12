#!/bin/bash

#  Debian 12 Cloud-Init image
sudo wget -P /root/ https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2

# Create a VM from the image
qm create 9000 --name debian12-cloudinit

# Import Cloud-Init Image 
qm set 9000 --scsi0 local-lvm:0,import-from=/root/debian-12-genericcloud-amd64.qcow2

# Create Template from VM
qm template 9000
