echo -e "\e[33mconfiguration nodejs repos \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log
echo -e "\e[33minstall nodejs\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log
echo -e "\e[33m add user application\e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[33mcreate application directory\e[0m"
rm-rf /app &>>/tmp/roboshop.log
mkdir /app
echo -e "\e[33m download the applicaion conent\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[33mextract the\e[0m"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[33m install nodejs dependencies\e[0m"
npm install &>>/tmp/roboshop.log
echo -e "\e[33msetup systemd service\e[0m"
cp /home/centos/roboshop-shell catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log
echo -e "\e[33mstart catalogue service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl start catalogue &>>/tmp/roboshop.log
echo -e "\e[33mcopy mongodb repo file\e[0m"
cp /home/centos/roboshop-shell mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
echo -e "\e[33minstall mongodb client\e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log
echo -e "\e[33mload schema\e[0m"
mongo --host mongodb-dev.devops73.in </app/schema/catalogue.js &>>/tmp/roboshop.log