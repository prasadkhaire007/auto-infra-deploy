#!/bin/bash

cd /home/ubuntu/infra-automation/terraform
echo "I am in that folder"
terraform init
echo "Intialisation"
terraform apply -auto-approve
echo "All Done"
echo"============================================================================================="
