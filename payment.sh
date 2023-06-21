etc -e "\e[34m install python36 \e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log
etc -e "\e[34m install python36 \e[0m"
useradd roboshop &>>/tmp/roboshop.log

etc -e "\e[34m create the application drive \e[0m" &>>/tmp/roboshop.log
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

etc -e "\e[34m download appliction content\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip  &>>/tmp/roboshop.log
cd /app
etc -e "\e[34m extract applicatio content\e[0m"
unzip /tmp/payment.zip &>>/tmp/roboshop.log
cd /app
etc -e "\e[34m download dependences \e[0m"
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log
etc -e "\e[34m setup systemd service\e[0m"
cp /home/centos/roboshop-shell/ payment.service /etc/systemd/system/payment.service &>>/tmp/roboshop.log
etc -e "\e[34m start the payment services\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable payment &>>/tmp/roboshop.log
systemctl restart payment &>>/tmp/roboshop.log