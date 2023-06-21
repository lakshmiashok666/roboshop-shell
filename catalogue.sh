source common.sh
component="catalogue"

nodejs

echo -e "${color}copy mongodb repo file${nocolor}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
echo -e "${color}install mongodb client${nocolor}"
yum install mongodb-org-shell -y &>>${log_path}
echo -e "${color}load schema${nocolor}"
mongo --host mongodb-dev.devops73.in </app/schema/catalogue.js &>>${log_path}