echo -e "\e[33m install maven \e[0m"
yum install maven -y &>>/tmp/roboshop.log
echo -e "\e[33m add aplplication user\e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[33m create application directory\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[33m download content file \\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[33m extract content\e[0m"
unzip /tmp/shipping.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[33m download maven dependencies \e[0m"
mvn clean package &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log
echo -e "\e[33m start systemd service \e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshop.log
echo -e "\e[33m start mysql service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable shipping &>>/tmp/roboshop.log
systemctl restart shipping &>>/tmp/roboshop.log
echo -e "\e[33m install mysql client"
yum install mysql -y &>>/tmp/roboshop.log
echo -e "\e[33m load schema \e[0m"
mysql -h mysql-dev.devops73.in -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshop.log
