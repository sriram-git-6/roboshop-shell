source common.sh

echo -e "/e[36m ################### Install nginx ##########################/e[0m" | tee -a ${log}
yum install nginx -y &>> ${log}
func_exit_status

echo -e "/e[36m ################### Copy roboshop configuration ##########################/e[0m" | tee -a ${log}
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>> ${log}
func_exit_status

echo -e "/e[36m ################### Clean old application content ##########################/e[0m" | tee -a ${log}
rm -rf /usr/share/nginx/html/* &>> ${log}
func_exit_status

echo -e "/e[36m ################### Download application content ##########################/e[0m" | tee -a ${log}
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> ${log}
func_exit_status

echo -e "/e[36m ################### Change directory ##########################/e[0m" | tee -a ${log}
cd /usr/share/nginx/html &>> ${log}
func_exit_status

echo -e "/e[36m ################### Extract application Content ##########################/e[0m" | tee -a ${log}
unzip /tmp/frontend.zip &>> ${log}
func_exit_status

echo -e "/e[36m ################### Restart nginx service ##########################/e[0m" | tee -a ${log}
systemctl enable nginx &>> ${log}
systemctl restart nginx &>> ${log}
func_exit_status
