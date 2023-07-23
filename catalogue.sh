echo -e "\e[36m >>>>>>>>>>>>>create catalogue service<<<<<<<<<<<<<<< \e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m >>>>>>>>>>>>>Create mongodb repofile<<<<<<<<<<<<<<< \e[0m"
cp mongo-repofile /etc/yum.repos.d/mongo.repo

echo -e "\e[36m >>>>>>>>>>>>>Download and install nodejs repos<<<<<<<<<<<<<<< \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m >>>>>>>>>>>>>install nodejs<<<<<<<<<<<<<<< \e[0m"
yum install nodejs -y

echo -e "\e[36m >>>>>>>>>>>>>Create a user for roboshop<<<<<<<<<<<<<<< \e[0m"
useradd roboshop

echo -e "\e[36m >>>>>>>>>>>>>remove application directory<<<<<<<<<<<<<<< \e[0m"
rm -rf /app

echo -e "\e[36m >>>>>>>>>>>>>Create application directory<<<<<<<<<<<<<<< \e[0m"
mkdir /app

echo -e "\e[36m >>>>>>>>>>>>>Download the application content <<<<<<<<<<<<<<< \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[36m >>>>>>>>>>>>>Change directory to app<<<<<<<<<<<<<<< \e[0m"
cd /app

echo -e "\e[36m >>>>>>>>>>>>>Extract the application content<<<<<<<<<<<<<<< \e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m >>>>>>>>>>>>>Install nodejs dependencies <<<<<<<<<<<<<<< \e[0m"
npm install

echo -e "\e[36m >>>>>>>>>>>>>Install mongo client<<<<<<<<<<<<<<< \e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m >>>>>>>>>>>>>Load catalogue schema<<<<<<<<<<<<<<< \e[0m"
mongo --host mongodb.devops746.online </app/schema/catalogue.js

echo -e "\e[36m >>>>>>>>>>>>>Daemon reload and restart service<<<<<<<<<<<<<<< \e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue