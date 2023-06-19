echo -e "\e[33m configuration nodejs repos \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log
echo -e "\e[33m install nodejs \e[0m"
yum install nodejs -y &>>/tmp/roboshop.log
echo -e "\e[33m add user application \e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[33m create application directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app
echo -e "\e[33m download application content \e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[33m extract the content \e[0m"
unzip /tmp/cart.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[33m install nodejs dependencies \e[0m"
npm install &>>/tmp/roboshop.log
echo -e "\e[33m setup systemd service \e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>/tmp/roboshop.log
echo -e "\e[33m start cart service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable cart &>>/tmp/roboshop.log
systemctl restart cart &>>/tmp/roboshop.log
