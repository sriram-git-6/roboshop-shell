nodejs()
{
  log=/tmp/roboshop.log

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Create user service <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp ${component}.service /etc/systemd/system/${component}.service &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Create mongodb repofile <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp mongo-repofile /etc/yum.repos.d/mongo.repo &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Download and install nodejs repos <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Install nodejs <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum install nodejs -y &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Create user for roboshop <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  useradd roboshop &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> delete app directory <<<<<<<<<<<\e[0m" | tee -a ${log}
  rm -rf /app &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Create application directory <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  mkdir /app &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Download application content <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Change directory to app <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cd /app &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Extract the application content <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  unzip /tmp/${component}.zip &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Install nodejs dependencies <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  npm install &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Install mongo client <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum install mongodb-org-shell -y &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Load user schema <<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  mongo --host mongodb.devops746.online </app/schema/${component}.js &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>>Daemon reload and restart service <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  systemctl daemon-reload &>> ${log}
  systemctl enable ${component} &>> ${log}
  systemctl restart ${component} &>> ${log}
}