echo -e "\e[34m install golang -y\e[0m"
yum install golang -y &>>/tmp/roboshop.log
echo -e "\e[34m add user\e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[34m  create application drive\e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app
echo -e "\e[34m download application content\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>/tmp/roboshop.log
echo -e "\e[34m extract the application content\e[0m"
unzip /tmp/dispatch.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[34m download denpencies\e[0m"
go mod init dispatch &>>/tmp/roboshop.log
go get &>>/tmp/roboshop.log
go build &>>/tmp/roboshop.log
echo -e "\e[34m setup systemd service\e[0m"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>>/tmp/roboshop.log
echo -e "\e[34m start dispatch service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl restart dispatch &>>/tmp/roboshop.log