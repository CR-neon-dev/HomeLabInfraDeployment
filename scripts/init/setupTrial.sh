#!/bin/bash

qm create 5000 --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0,tag=3

qm importdisk 5000 /var/lib/vz/template/iso/jammy-server-cloudimg-amd64-disk-kvm.img local-lvm

qm set 5000 scsihw virtio-scsi-pci --scsi0 local-lvm:vm-5000-disk-0

qm set 5000 --ide2 local-lvm:cloudinit

qm set 5000 --boot c --bootdisk scsi0
 
qm set 5000 --serial0 socket --vga serial0
