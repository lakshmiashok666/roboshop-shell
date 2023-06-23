component="catalogue"
color="\e[33m"
nocolor="\e[0m"
log_path="/tmp/roboshop.log"
app_path="/app"
app_pre_setup()
{
  stat_check()
  {
    if [ $? -eq 0 ]; then
        echo success
      else
        echo failure
      fi
  }
 echo -e "${color} extract the content ${nocolor}"
 cd ${app_path}
 unzip /tmp/$component.zip &>>${log_path}
 stat_check $?
 echo -e "${color} add application user ${nocolor}"
 id roboshop &>>${log_path}
 if [ $? -eq 1 ]; then
 useradd roboshop &>>${log_path}
 fi
 stat_check $?
 echo -e "${color} create application directory${nocolor}"
 rm -rf ${app_path} &>>${log_path}
 mkdir ${app_path}
 stat_check $?
 echo -e "${color} download the application content${nocolor}"
 curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_path}
 cd ${app_path}
 stat_check $?


}
  systemd_setup()
{
 echo -e "${color} setup systemd service ${nocolor}"
 cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_path}

 stat_check $?
 echo -e "${color}start catalogue service ${nocolor}"
 systemctl daemon-reload &>>${log_path}
 systemctl enable $component &>>${log_path}
 systemctl restart $component &>>${log_path}
 stat_check $?
}

nodejs()
{
 echo -e "${color}configuration nodejs repos ${nocolor}"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_path}
 echo -e "${color}install nodejs ${nocolor}"
 yum install nodejs -y &>>${log_path}

 app_pre_setup

 systemd_setup

 echo -e "${color} install nodejs dependencies ${nocolor}"
 npm install &>>${log_path}


}
mongo_load_schema()
{
 echo -e "${color}copy mongodb repo file${nocolor}"
 cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_path}
 echo -e "${color}install mongodb client${nocolor}"
 yum install mongodb-org-shell -y &>>${log_path}
 echo -e "${color}load schema${nocolor}"
 mongo --host mongodb-dev.devops73.in <${app_path}/schema/$component.js &>>${log_path}


}
mysql_shema_setup()
{
 echo -e "\e[33m install mysql client"
 yum install mysql -y &>>${log_path}
 echo -e "\e[33m load schema \e[0m"
 mysql -h mysql-dev.devops73.in -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>${log_path}


}

maven()
{
 echo -e "${color} install maven ${nocolor}"
 yum install maven -y &>>${log_path}
 app_pre_setup

 echo -e "${color} download maven dependencies ${nocolor}"
 mvn clean package &>>${log_path}
 mv target/$component-1.0.jar $component.jar &>>${log_path}

 mysql_shema_setup
 systemd_setup

}
python() {

 echo -e "${color} install python ${nocolor}"
 yum install python36 gcc python3-devel -y &>>${log_path}
 stat_check $?
 app_pre_setup
 echo -e "${color} install application dependencies ${nocolor}"
 cd /app
 pip3.6 install -r requirements.txt &>>${log_path}
 stat_check $?
 systemd_setup

}