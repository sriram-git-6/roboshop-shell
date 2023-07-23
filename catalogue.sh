log=${log}
echo -e "\e[36m >>>>>>>>>>>>>create catalogue service<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
cp catalogue.service /etc/systemd/system/catalogue.service &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>Create mongodb repofile<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
cp mongo-repofile /etc/yum.repos.d/mongo.repo &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>Download and install nodejs repos<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>install nodejs<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
yum install nodejs -y &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>Create a user for roboshop<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
useradd roboshop &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>remove application directory<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
rm -rf /app &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>Create application directory<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
mkdir /app &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>Download the application content <<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>Change directory to app<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
cd /app &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>Extract the application content<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
unzip /tmp/catalogue.zip &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>Install nodejs dependencies <<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
npm install &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>Install mongo client<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
yum install mongodb-org-shell -y &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>Load catalogue schema<<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
mongo --host mongodb.devops746.online </app/schema/catalogue.js &>> ${log}

echo -e "\e[36m >>>>>>>>>>>>>>Daemon reload and restart service<<<<<<<<<<<<<<< \e[0m" | tee -a ${log}
systemctl daemon-reload &>> ${log}
systemctl enable catalogue &>> ${log}
systemctl restart catalogue &>> ${log}