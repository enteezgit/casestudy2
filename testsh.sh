proxies=$(env | grep proxy | tr '\n' ' ')
echo "Proxies obtained: "$proxies

#Run the Management node container in TEST environment
echo "Create management node container in docker"
mgmtNodeCont=$(sudo docker run -td -e ROOT_PASS="pass"  -p 8023:22 -p 8306:3306 -p 8186:1186 --name mgmtNodeTEST clusterimage)
#Retrieve the node IP address
mgmtIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${mgmtNodeCont})
echo "IP of management node is:",$mgmtIP

#Run the 1st Data node container in TEST environment
echo "Create the 1st data node container in docker"
dataNodeCont1=$(sudo docker run -td -e ROOT_PASS="pass"  -p 8024:22 -p 9306:3306 -p 9202:2202 --name dataNodeTEST1 clusterimage)
#Retrieve the node IP address
dataIP1=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${dataNodeCont1})
echo "IP of first data node is:",$dataIP1


#Run the 2nd Data node container in TEST environment
echo "Create the 2nd data node container in docker"
dataNodeCont2=$(sudo docker run -td -e ROOT_PASS="pass"  -p 8025:22 -p 7306:3306 -p 7202:2202 --name dataNodeTEST2 clusterimage)
#Retrieve the node IP address
dataIP2=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${dataNodeCont2})
echo "IP of second data node is:",$dataIP2

#Run the SQL node container in TEST environment
echo "Create sql node container in docker"
sqlNodeCont=$(sudo docker run -td -e ROOT_PASS="pass"  -p 8026:22 -p 6306:3306 --name sqlNodeTEST clusterimage)
#Retrieve the node IP address
sqlIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${sqlNodeCont})
echo "IP of sql node is:",$sqlIP

export ANSIBLE_WORKSPACE=/root/demo/casestudy/ansible
#Change to ansible workspace
echo "Changing into ansible dir at:",$ANSIBLE_WORKSPACE
cd $ANSIBLE_WORKSPACE
pwd
echo "[WebServer]" > hosts
echo $webIP  "ansible_ssh_pass=pass" >> hosts
echo "" >> hosts
echo "[DbServer]" >> hosts
echo $mgmtIP  "ansible_ssh_pass=pass" >> hosts
echo $dataIP1  "ansible_ssh_pass=pass" >> hosts
echo $dataIP2  "ansible_ssh_pass=pass" >> hosts
echo $sqlIP  "ansible_ssh_pass=pass" >> hosts

echo "Hosts file is written. With following contents"
cat hosts

#following env variable disables host key checking - when not using key based authentication
export ANSIBLE_HOST_KEY_CHECKING=False

echo "Run Ansible Playbook for DB Server host to Install MySQL"
#Run Ansible Playbook for DB Server host to Install MySQL (this playbook should also enable remote login for the user)
#ansible-playbook -i hosts -u root mgmtnode.yml --extra-vars "host=$dbIP mysql_root_password=pass123 $proxies"
ansible-playbook -i hosts -u root mgmtnode.yml --extra-vars "host=$mgmtIP dataIP1=$dataIP1 dataIP2=$dataIP2 sqlIP=$sqlIP $proxies"

ansible-playbook -i hosts -u root datanode.yml --extra-vars "host=$dataIP1 mgmtIP=$mgmtIP $proxies"

ansible-playbook -i hosts -u root datanode.yml --extra-vars "host=$dataIP2 mgmtIP=$mgmtIP $proxies"

ansible-playbook -i hosts -u root sqlnode.yml --extra-vars "host=$sqlIP mgmtIP=$mgmtIP $proxies"

ansible-playbook -i hosts -u root startcluster.yml --extra-vars "mgmtIP=$mgmtIP dataIP1=$dataIP1 dataIP2=$dataIP2 sqlIP=$sqlIP mysql_root_password=pass123 $proxies"
