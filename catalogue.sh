echo ">>>>>>>>>>>>>create catalogue service<<<<<<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service

echo ">>>>>>>>>>>>>Create mongodb repofile<<<<<<<<<<<<<<<"
cp mongo-repofile /etc/yum.repos.d/mongo.repo

echo ">>>>>>>>>>>>>Download and install nodejs repos<<<<<<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo ">>>>>>>>>>>>>install nodejs<<<<<<<<<<<<<<<"
yum install nodejs -y

echo ">>>>>>>>>>>>>Create a user for roboshop<<<<<<<<<<<<<<<"
useradd roboshop

echo ">>>>>>>>>>>>>Create application directory<<<<<<<<<<<<<<<"
mkdir /app

echo ">>>>>>>>>>>>>Download the application content <<<<<<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo ">>>>>>>>>>>>>Change directory to app<<<<<<<<<<<<<<<"
cd /app

echo ">>>>>>>>>>>>>Extract the application content<<<<<<<<<<<<<<<"
unzip /tmp/catalogue.zip

echo ">>>>>>>>>>>>>Install nodejs dependencies <<<<<<<<<<<<<<<"
npm install

echo ">>>>>>>>>>>>>Install mongo client<<<<<<<<<<<<<<<"
yum install mongodb-org-shell -y

echo ">>>>>>>>>>>>>Load catalogue schema<<<<<<<<<<<<<<<"
mongo --host mongodb.devops746.online </app/schema/catalogue.js

echo ">>>>>>>>>>>>>Daemon reload and restart service<<<<<<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue