#!/bin/bash
read -p "Do you want to Create VMs as well!:" CHOICE
echo "Running the script now....!"

echo "Creating Azure Resource Group"
az group create -l eastus -n CHAITHUAZ

echo "Creating Azure Virtual Network"
az network vnet create -g CHAITHUAZ -n CHAITHUAZ-vNET1 --address-prefix 10.1.0.0/16 \
--subnet-name CHAITHUAZ-Subnet-1 --subnet-prefix 10.1.1.0/24 -l eastus

echo "Creating Azure Subnets"
az network vnet subnet create -g CHAITHUAZ --vnet-name CHAITHUAZ-vNET1 -n CHAITHUAZ-Subnet-2 \
--address-prefix 10.1.2.0/24
az network vnet subnet create -g CHAITHUAZ --vnet-name CHAITHUAZ-vNET1 -n CHAITHUAZ-Subnet-3 \
--address-prefix 10.1.3.0/24

echo "Creating Azure NSG and RULES"
az network nsg create -g CHAITHUAZ -n CHAITHUAZ_NSG1
az network nsg rule create -g CHAITHUAZ --nsg-name CHAITHUAZ_NSG1 -n CHAITHUAZ_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'      --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow    --protocol Tcp --description "Allowing All Traffic For Now"

echo "Creating Azure Availability Set"
az vm availability-set create --name EAST-AVSET1 -g CHAITHUAZ --location eastus \
--platform-fault-domain-count 3 --platform-update-domain-count 5

if [ $CHOICE = "Yes" || $CHOICE = "yes"]
then 

echo "Creating Azure Virtual Machines"
az vm create --resource-group CHAITHUAZ --name CHAITHUAZTestVM1 --image UbuntuLTS --vnet-name CHAITHUAZ-vNET1 \
--subnet CHAITHUAZ-Subnet-1 --admin-username testuser --admin-password "Chaithu@1234" --size Standard_B1s \
--availability-set EAST-AVSET1 --nsg CHAITHUAZ_NSG1 

az vm create --resource-group CHAITHUAZ --name CHAITHUAZTestVM2 --image UbuntuLTS --vnet-name CHAITHUAZ-vNET1 \
--subnet CHAITHUAZ-Subnet-2 --admin-username testuser --admin-password "Chaithu@1234" --size Standard_B1s \
--availability-set EAST-AVSET1 --nsg CHAITHUAZ_NSG1 

fi