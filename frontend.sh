echo -e "\e[33minstalling nginx\e[0m"
yum install nginx -y &>>/tmp/roboshop.log
echo -e "\e[33mremoving old app content\e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log
echo -e "\e[33mdownloading frontend\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log
echo -e "\e[33mextract frontend\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>/tmp/roboshop.log
echo -e "\e[33mupdating frontend roboshop configuration\e[0m"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[33mstarting nginx server\e[0m"
systemctl enable nginx &>>/tmp/roboshop.log
systemctl restart nginx &>>/tmp/roboshop.log