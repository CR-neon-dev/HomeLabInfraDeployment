#!/bin/bash
#Run this script to setup all init resources to create the VMs using terraform

echo Downloading Image and Creating Template from it
./setupTemplateVM.sh

echo Creating configuration file to install Quemu-Guest-Agent
./snippetQuemuGuestService.sh