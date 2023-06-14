echo -e "\e[33mcopy mongodb repo file\e[0m"
cp mongodb.repo "/etc/yum.repos.d/mongodb.repo"
echo -e "\e[33minstalling mongodb server\e[0m"
yum install mongodb-org -y
##modify confg file
echo -e "\e[33mstart mongodb service\e[0m"
systemctl enable mongod
systemctl restart mongod