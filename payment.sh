echo -e "\e[33m install python\e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log

echo -e "\e[34m add appliction user \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[34m create the application directory \e[0m" &>>/tmp/roboshop.log
rm -rf /app &>>/tmp/roboshop.log
mkdir /app
echo -e "\e[34m download application content\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip  &>>/tmp/roboshop.log
cd /app
echo -e "\e[34m extract application content\e[0m"
unzip /tmp/payment.zip &>>/tmp/roboshop.log

echo -e "\e[34m download dependencies \e[0m"
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log

echo -e "\e[34m setup systemd service\e[0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>/tmp/roboshop.log
echo -e "\e[34m start the payment services\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable payment &>>/tmp/roboshop.log
systemctl restart payment &>>/tmp/roboshop.log