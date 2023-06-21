component="catalogue"
color="\e[33m"
nocolor="\e[0m"
log_path="/tmp/roboshop.log"
app_path="/app"
app_pre_setup()
{
  echo -e "${color}extract the content${nocolor}"
   unzip /tmp/$component.zip &>>${log_path}
   cd ${app_path}
   echo -e "${color} add user application${nocolor}"
    useradd roboshop &>>${log_path}
    echo -e "${color} create application directory${nocolor}"
     rm -rf ${app_path} &>>${log_path}
     mkdir ${app_path}
}
systemctl(){
  echo -e "${color}start catalogue service ${nocolor}"
  systemctl daemon-reload &>>${log_path}
   systemctl enable $component &>>${log_path}
   systemctl restart $component &>>${log_path}
}

nodejs(){
 echo -e "${color}configuration nodejs repos ${nocolor}"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_path}
 echo -e "${color}install nodejs\e[0m"
 yum install nodejs -y &>>${log_path}

 echo -e "${color} download the applicaion conent${nocolor}"
 curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_path}
 cd ${app_path}
 echo -e "${color} install nodejs dependencies ${nocolor}"
 npm install &>>${log_path}
 echo -e "${color} setup systemd service ${nocolor}"
 cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_path}

}
mongo_load_schema()
{
  echo -e "${color}copy mongodb repo file${nocolor}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
  echo -e "${color}install mongodb client${nocolor}"
  yum install mongodb-org-shell -y &>>${log_path}
  echo -e "${color}load schema${nocolor}"
  mongo --host mongodb-dev.devops73.in </app/schema/catalogue.js &>>${log_path}
}