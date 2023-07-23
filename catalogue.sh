echo -e "\e[36m >>>>>>>>>>>>>create catalogue service<<<<<<<<<<<<<<< \e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Create mongodb repofile<<<<<<<<<<<<<<< \e[0m"
cp mongo-repofile /etc/yum.repos.d/mongo.repo > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Download and install nodejs repos<<<<<<<<<<<<<<< \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>install nodejs<<<<<<<<<<<<<<< \e[0m"
yum install nodejs -y > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Create a user for roboshop<<<<<<<<<<<<<<< \e[0m"
useradd roboshop > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>remove application directory<<<<<<<<<<<<<<< \e[0m"
rm -rf /app > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Create application directory<<<<<<<<<<<<<<< \e[0m"
mkdir /app > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Download the application content <<<<<<<<<<<<<<< \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Change directory to app<<<<<<<<<<<<<<< \e[0m"
cd /app > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Extract the application content<<<<<<<<<<<<<<< \e[0m"
unzip /tmp/catalogue.zip > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Install nodejs dependencies <<<<<<<<<<<<<<< \e[0m"
npm install > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Install mongo client<<<<<<<<<<<<<<< \e[0m"
yum install mongodb-org-shell -y > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Load catalogue schema<<<<<<<<<<<<<<< \e[0m"
mongo --host mongodb.devops746.online </app/schema/catalogue.js > /tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>>>>>Daemon reload and restart service<<<<<<<<<<<<<<< \e[0m"
systemctl daemon-reload > /tmp/roboshop.log
systemctl enable catalogue > /tmp/roboshop.log
systemctl restart catalogue > /tmp/roboshop.log