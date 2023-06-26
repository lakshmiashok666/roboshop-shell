source common.sh
echo -e "${color}installing nginx${nocolor}"
yum install nginx -y &>>/tmp/roboshop.log
stat_check $?
echo -e "${color}removing old app content${nocolor}"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log
stat_check $?
echo -e "${color}downloading frontend${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log
stat_check $?
echo -e "${color}extract frontend${nocolor}"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>/tmp/roboshop.log
stat_check $?
echo -e "${color}mupdating frontend roboshop configuration${nocolor}"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf
stat_check $?
echo -e "${color}starting nginx server${nocolor}"
systemctl enable nginx &>>/tmp/roboshop.log
systemctl restart nginx &>>/tmp/roboshop.log
stat_check $?