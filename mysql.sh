mysql_root_password=$1 #This line assigns the first command-line argument to the variable mysql_root_password.
# When you run the script, you can pass the MySQL root password as an argument,
# and it will be stored in this variable for later use.

if [ -z "${mysql_root_password}" ]; then #This is a conditional statement.
# It checks if the mysql_root_password variable is empty or not.
# The -z flag checks if the length of the variable is zero (empty).
# If the variable is empty, it means the MySQL root password was not provided as an argument,
# so the script displays "input password missing" and exits with an error code of 1 using exit 1.

  echo input password missing
  exit 1
fi
cp mysql.repo /etc/yum.repos.d/mysql.repo
yum module disable mysql -y
yum install mysql-community-server -y
systemctl enable mysqld
systemctl restart mysqld
mysql_secure_installation --set-root-pass ${mysql_root_password}
