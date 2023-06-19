echo -e "\e[33m configuration nodejs repos \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log
echo -e "\e[33m install nodejs \e[0m"
yum install nodejs -y &>>/tmp/roboshop.log
echo -e "\e[33m add roboshop user \e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[33m create appliction directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app
echo -e "\e[33m download the apllication content\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[33m extract user file \e[0m"
unzip /tmp/user.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[33m install nodejs dependencies \e[0m"
npm install &>>/tmp/roboshop.log
echo -e "\e[33m setup systemd service \e[0m"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>/tmp/roboshop.log
echo -e "\e[33m start user service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable user &>>/tmp/roboshop.log
systemctl restart user &>>/tmp/roboshop.log
echo -e "\e[33m copy mongo repo file \e[0m"
cp /home/centos/roboshop-shell/mongodb /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
echo -e "\e[33m install mongodb client \e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log
echo -e "\e[33m load schema \e[0m"
mongo --host mongodb-dev.devops73.in </app/schema/user.js &>>/tmp/roboshop.log