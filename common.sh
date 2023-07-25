log=/tmp/roboshop.log

func_prereq()
{
    echo -e "\e[36m >>>>>>>>>>>>>>>>>> Create user service <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    cp ${component}.service /etc/systemd/system/${component}.service &>> ${log}

    echo -e "\e[36m >>>>>>>>>>>>>>>>>> Create user for roboshop <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    useradd roboshop &>> ${log}

    echo -e "\e[36m >>>>>>>>>>>>>>>>>> delete app directory <<<<<<<<<<<\e[0m" | tee -a ${log}
    rm -rf /app &>> ${log}

    echo -e "\e[36m >>>>>>>>>>>>>>>>>> Create application directory <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    mkdir /app &>> ${log}

    echo -e "\e[36m >>>>>>>>>>>>>>>>>> Download application content <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> ${log}

    echo -e "\e[36m >>>>>>>>>>>>>>>>>> Change directory to app <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    cd /app &>> ${log}

    echo -e "\e[36m >>>>>>>>>>>>>>>>>> Extract the application content <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    unzip /tmp/${component}.zip &>> ${log}
}

func_systemd()
{
    echo -e "\e[36m >>>>>>>>>>>>>>>>>>Daemon reload and restart service <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    systemctl daemon-reload &>> ${log}
    systemctl enable ${component} &>> ${log}
    systemctl restart ${component} &>> ${log}
}

func_schema_setup()
{
  if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[36m >>>>>>>>>>>>>>>>>> Install mongo client <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    yum install mongodb-org-shell -y &>> ${log}

    echo -e "\e[36m >>>>>>>>>>>>>>>>>> Load user schema <<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    mongo --host mongodb.devops746.online </app/schema/${component}.js &>> ${log}
  fi

  if  [ "${schema_type}" == "mysql" ]; then
     echo -e "\e[36m >>>>>>>>>>>>>>>>Install mysql client<<<<<<<<<<<\e[0m" | tee -a ${log}
     yum install mysql -y &>> ${log}

     echo -e "\e[36m >>>>>>>>>>>>>>>>Load schema<<<<<<<<<<<\e[0m" | tee -a ${log}
     mysql -h mysql.devops746.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>> ${log}
  fi
}


func_nodejs_cat_user_cart()
{
  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Create mongodb repofile <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp mongo-repofile /etc/yum.repos.d/mongo.repo &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Download and install nodejs repos <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Install nodejs <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum install nodejs -y &>> ${log}

  func_prereq

  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Install nodejs dependencies <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  npm install &>> ${log}

  func_schema_setup

  func_systemd

}

func_javaship()
{
  echo -e "\e[36m >>>>>>>>>>>>>>>>Install maven<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum install maven -y &>> ${log}

  func_prereq

  echo -e "\e[36m >>>>>>>>>>>>>>>>Build the package<<<<<<<<<<<\e[0m" | tee -a ${log}
  mvn clean package &>> ${log}
  mv target/${component}-1.0.jar ${component}.jar &>> ${log}

  echo -e "\e[36m >>>>>>>>>>>>>>>>Daemon Reload<<<<<<<<<<<\e[0m" | tee -a ${log}
  systemctl daemon-reload &>> ${log}

  func_schema_setup

  func_systemd
}

func_python_payment()
{
echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>Install python<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum install python36 gcc python3-devel -y &>>${log}

func_prereq

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>Download dependencies<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
pip3.6 install -r requirements.txt &>>${log}

func_systemd
}

func_go_dispatch()
{
echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>Install golang<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum install golang -y &>>${log}

func_prereq

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>Download the dependencies and build<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
go mod init ${component} &>>${log}
go get &>>${log}
go build &>>${log}

func_systemd
}