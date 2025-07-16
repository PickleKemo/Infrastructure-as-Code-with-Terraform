#!/usr/bin/env bash
ENV=$1
cd envs/$ENV
terraform init -input=false
terraform plan -out=tfplan -input=false
terraform apply -auto-approve tfplan
