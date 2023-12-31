color="\e[33m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"
user_id=$(id -u)
if [ $user_id -ne 0 ]; then
    echo script should be running with sudo
    exit 1
    fi
 stat_check()
  {
    if [ $1 -eq 0 ]; then
        echo success
      else
       echo failure
        exit 1
       fi

   }
 app_pre_setup()
{
 echo -e "${color} add application user ${nocolor}"
 id roboshop &>>${log_file}
 if [ $? -eq 1 ]; then
 useradd roboshop &>>${log_file}
 fi
 stat_check $?
 echo -e "${color} create application directory${nocolor}"
 rm -rf /app &>>${log_file}
 mkdir /app
 stat_check $?
 echo -e "${color} download the application content${nocolor}"
 curl -l -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
 stat_check $?
 echo -e "${color} extract the content ${nocolor}"
 cd ${app_path}
 unzip /tmp/$component.zip &>>${log_file}
 stat_check $?
}
  systemd_setup()
{
 echo -e "${color} setup systemd service ${nocolor}"
 cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_file}
 sed -i -e "s/roboshop_app_password/$roboshop_app_password/" /etc/systemd/system/$component.service
 stat_check $?
 echo -e "${color}start $component service ${nocolor}"
 systemctl daemon-reload &>>${log_file}
 systemctl enable $component &>>${log_file}
 systemctl restart $component &>>${log_file}
 stat_check $?
}

nodejs()
{
 echo -e "${color}configuration nodejs repos ${nocolor}"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
 stat_check $?
 echo -e "${color}install nodejs ${nocolor}"
 yum install nodejs -y &>>${log_file}
 stat_check $?

 app_pre_setup

 systemd_setup

 echo -e "${color} install nodejs dependencies ${nocolor}"
 npm install &>>${log_file}
 stat_check $?


}
mongo_load_schema()
{
 echo -e "${color}copy mongodb repo file${nocolor}"
 cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
 stat_check $?
 echo -e "${color}install mongodb client${nocolor}"
 yum install mongodb-org-shell -y &>>${log_file}
 stat_check $?
 echo -e "${color}load schema${nocolor}"
 mongo --host mongodb-dev.devops73.in <${app_path}/schema/$component.js &>>${log_file}
 stat_check $?


}
mysql_schema_setup()
{
 echo -e "${color} install mysql client ${nocolor}"
 yum install mysql -y &>>${log_file}
 stat_check $?
 echo -e "${color} load schema ${nocolor}"
 mysql -h mysql-dev.devops73.in -uroot -p${mysql_root_password} </app/schema/${component}.sql &>>${log_file}
 stat_check $?

}

maven()
{
 echo -e "${color} install maven ${nocolor}"
 yum install maven -y &>>${log_file}
 stat_check $?
 app_pre_setup

 echo -e "${color} download maven dependencies ${nocolor}"
 mvn clean package &>>${log_file}
 mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
 stat_check $?

 mysql_schema_setup
 systemd_setup

}
python() {

 echo -e "${color} install python ${nocolor}"
 yum install python36 gcc python3-devel -y &>>${log_file}
 stat_check $?

 app_pre_setup

 echo -e "${color} install application dependencies ${nocolor}"
 cd /app
 pip3.6 install -r requirements.txt &>>/tmp/roboshop.log

 stat_check $?
 systemd_setup

}