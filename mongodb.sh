cp mongo-repofile /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
yum install mongodb-org -y
#we need to update ip in /etc/mongod.conf
systemctl enable mongod
systemctl restart mongod