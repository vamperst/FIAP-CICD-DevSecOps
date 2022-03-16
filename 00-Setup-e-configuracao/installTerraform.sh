!#/bin/bash 

sudo apt-get install unzip -y
#version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
#echo $version
#url="https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')_linux_amd64.zip"
url="https://releases.hashicorp.com/terraform/1.1.6/terraform_1.1.6_linux_amd64.zip"
echo $url
wget $url

unzip terraform*

sudo mv terraform /usr/local/bin/

