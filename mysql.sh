echo -e "\e[33m disable mysql default version\e[0m"
yum module disable mysql -y &>>/tmp/roboshop.log
echo -e "\e[33m copy mysql repo file\e[0m"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log
echo -e "\e[33m\ install mysql community server\e[0m"
yum install mysql-community-server -y &>>/tmp/roboshop.log
echo -e "\e[33m start mysql service\e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl restart mysqld &>>/tmp/roboshop.log
echo -e "\e[33m setup mysql password\e[0m"
mysql_secure_installation --set-root-pass @1 &>>/tmp/roboshop.log
