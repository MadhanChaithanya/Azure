#!/bin/bash
echo "Creating RED-RG"

echo "Creating Azure Resource Group"
az group create -l eastus -n RED-RG

echo "Creating Azure Virtual Network"
az network vnet create -g RED-RG -n RED-RG-vNET1 --address-prefix 10.1.0.0/16 \
--subnet-name RED-RG-Subnet-1 --subnet-prefix 10.1.1.0/24 -l eastus

echo "Creating Azure NSG and RULES"
az network nsg create -g RED-RG -n RED-RG_NSG1
az network nsg rule create -g RED-RG --nsg-name RED-RG_NSG1 -n RED-RG_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'      --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow    --protocol Tcp --description "Allowing All Traffic For Now"

echo "Creating Azure Availability Set"
az vm availability-set create --name EAST-AVSET1 -g RED-RG --location eastus \
--platform-fault-domain-count 3 --platform-update-domain-count 5

echo "Creating ORANGE-RG"

echo "Creating Azure Resource Group"
az group create -l eastus -n ORANGE-RG

echo "Creating Azure Virtual Network"
az network vnet create -g ORANGE-RG -n ORANGE-RG-vNET1 --address-prefix 172.16.0.0/16 \
--subnet-name ORANGE-RG-Subnet-1 --subnet-prefix 172.16.1.0/24 -l eastus

echo "Creating Azure NSG and RULES"
az network nsg create -g ORANGE-RG -n ORANGE-RG_NSG1
az network nsg rule create -g ORANGE-RG --nsg-name ORANGE-RG_NSG1 -n ORANGE-RG_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'      --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow    --protocol Tcp --description "Allowing All Traffic For Now"

echo "Creating Azure Availability Set"
az vm availability-set create --name EAST-AVSET1 -g ORANGE-RG --location eastus \
--platform-fault-domain-count 3 --platform-update-domain-count 5

echo "Creating Azure Virtual Machines"
echo "Creating RED-RG Virtual Machines"
az vm create --resource-group RED-RG --name RED-RGTestVM1 --image UbuntuLTS --vnet-name RED-RG-vNET1 \
--subnet RED-RG-Subnet-1 --admin-username testuser --admin-password "Chaithu@1234" --size Standard_B1s \
--availability-set EAST-AVSET1 --nsg RED-RG_NSG1
echo "Creating ORANGE-RG Virtual Machines"
az vm create --resource-group ORANGE-RG --name ORANGE-RGTestVM1 --image UbuntuLTS --vnet-name ORANGE-RG-vNET1 \
--subnet ORANGE-RG-Subnet-1 --admin-username testuser --admin-password "Chaithu@1234" --size Standard_B1s \
--availability-set EAST-AVSET1 --nsg ORANGE-RG_NSG1


############################################################
echo "Creating BLUE-RG"

echo "Creating Azure Resource Group"
az group create -l westus -n BLUE-RG

echo "Creating Azure Virtual Network"
az network vnet create -g BLUE-RG -n BLUE-RG-vNET1 --address-prefix 192.168.0.0/16 \
--subnet-name BLUE-RG-Subnet-1 --subnet-prefix 192.168.1.0/24 -l westus

echo "Creating Azure NSG and RULES"
az network nsg create -g BLUE-RG -n BLUE-RG_NSG1
az network nsg rule create -g BLUE-RG --nsg-name BLUE-RG_NSG1 -n BLUE-RG_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'      --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow    --protocol Tcp --description "Allowing All Traffic For Now"

echo "Creating Azure Availability Set"
az vm availability-set create --name WEST-AVSET1 -g BLUE-RG --location westus \
--platform-fault-domain-count 3 --platform-update-domain-count 5

echo "Creating BLUE-RG Virtual Machine"
az vm create --resource-group BLUE-RG --name BLUE-RGTestVM1 --image UbuntuLTS --vnet-name BLUE-RG-vNET1 \
--subnet BLUE-RG-Subnet-1 --admin-username testuser --admin-password "Chaithu@1234" --size Standard_B1s \
--availability-set WEST-AVSET1 --nsg BLUE-RG_NSG1
