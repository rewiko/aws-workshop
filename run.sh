#!/bin/bash
sudo apt update
sudo apt install nodejs npm jq awscli git -y
# sudo apt install nginx -y
# sudo systemctl enable nginx
# sudo systemctl start nginx
echo "Deploy new version 3"
# # sudo systemctl status nginx
# sudo mkdir -p /var/www/tutorial
# echo "<h1>HELLO from $(hostname -f)</h1>" | sudo tee -a /var/www/tutorial/index.html >/dev/null

export region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
export DBPassword=$(aws secretsmanager get-secret-value --region ${region} --secret-id workshop-v1-db-password --query SecretString --output text)
export DBHostname=$(aws secretsmanager get-secret-value --region ${region} --secret-id workshop-v1-db-hostname --query SecretString --output text)
export hostname=$(hostname -f)

git clone https://github.com/rewiko/aws-workshop.git
cd aws-workshop/application
npm install
node main.js
# create system service to start nodejs
