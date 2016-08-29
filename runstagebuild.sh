#Clean docker containers
sudo docker kill websrvSTAGE mgmtNodeSTAGE dataNode1STAGE dataNode2STAGE sqlNodeSTAGE testsrvSTAGE || echo "Containers clean"
sudo docker rm websrvSTAGE mgmtNodeSTAGE dataNode1STAGE dataNode2STAGE sqlNodeSTAGE testsrvSTAGE || echo "Containers clean"

export ANSIBLE_WORKSPACE=$WORKSPACE/ansible
echo WORKSPACE $WORKSPACE
echo ANSIBLE_WORKSPACE $ANSIBLE_WORKSPACE
export CHEF_REPO_WORKSPACE=$WORKSPACE/chef-repo
echo $CHEF_REPO_WORKSPACE

cd $CHEF_REPO_WORKSPACE
#kclwt=$(knife node list | grep websrvSTAGE | tr '\n' ' ')
#if [[ "${kclwt}" == *"websrvSTAGE"* ]];then
#    echo "Delete node from chef server"
    knife node delete websrvSTAGE -y || echo "Knife node ok"
#fi

#kclwt=$(knife client list | grep websrvSTAGE | tr '\n' ' ')
#if [[ "${kclwt}" == *"websrvSTAGE"* ]];then
#	echo "Delete client from chef server"
    knife client delete websrvSTAGE -y || echo "Knife client ok"
#fi

cd $WORKSPACE

warFile='webapp.war'

echo "Proxies obtained: "$proxies

echo "Attempting to connect to SVN Repo"
#Sync with SVN repo
svn co --username $svnUser --depth=immediates --password $svnPasswd --no-auth-cache --non-interactive --trust-server-cert  https://svn.persistent.co.in/svn/DevOps_Compt/$svnrepodir .

echo "Attempting to check status of war"
#Determine if the WAR file is pre-existing in the SVN repo.  If the file pre-existed in repo following command would return M
svn status | awk '$2 == "webapp.war" {print $1}'

cwd=pwd
echo "Current dir is: "`pwd`

if [ ! -f $warFile ]; then
	exit 125
fi

fileStatus=`svn status webapp.war | awk '$2 == "readme.txt" {print $1}'`

svn update --username $svnUser --password $svnPasswd --no-auth-cache --non-interactive --trust-server-cert #Update the existing file to SVN

echo "Commiting into svn as Ready for STAGE"
svn commit --username $svnUser --password $svnPasswd --no-auth-cache --non-interactive --trust-server-cert -m "Ready for STAGE" #Commit the file to SVN

#Run the Web Server container in STAGE environment
echo "Create web server container in docker"
webSrvCont=$(sudo docker run -td -e ROOT_PASS="pass" -p 8022:22 -p 8088:8080 --name websrvSTAGE enteezgit/casestudy:1.0)
#Retrieve the server IP address
webIP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${webSrvCont})
echo "IP of web server is:",$webIP


#Run the Management node container in STAGE environment
echo "Create management node container in docker"
mgmtNodeCont=$(sudo docker run -td -e ROOT_PASS="pass"  -p 8023:22 -p 8306:3306 -p 8186:1186 --name mgmtNodeSTAGE enteezgit/casestudy:1.0)
#Retrieve the node IP address
mgmtIP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${mgmtNodeCont})
echo "IP of management node is:",$mgmtIP

#Run the 1st Data node container in STAGE environment
echo "Create the 1st data node container in docker"
dataNodeCont1=$(sudo docker run -td -e ROOT_PASS="pass"  -p 8024:22 -p 9306:3306 -p 9202:2202 --name dataNode1STAGE enteezgit/casestudy:1.0)
#Retrieve the node IP address
dataIP1=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${dataNodeCont1})
echo "IP of first data node is:",$dataIP1


#Run the 2nd Data node container in STAGE environment
echo "Create the 2nd data node container in docker"
dataNodeCont2=$(sudo docker run -td -e ROOT_PASS="pass"  -p 8025:22 -p 7306:3306 -p 7202:2202 --name dataNode2STAGE enteezgit/casestudy:1.0)
#Retrieve the node IP address
dataIP2=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${dataNodeCont2})
echo "IP of second data node is:",$dataIP2

#Run the SQL node container in STAGE environment
echo "Create sql node container in docker"
sqlNodeCont=$(sudo docker run -td -e ROOT_PASS="pass"  -p 8026:22 -p 6306:3306 --name sqlNodeSTAGE enteezgit/casestudy:1.0)
#Retrieve the node IP address
sqlIP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${sqlNodeCont})
echo "IP of sql node is:",$sqlIP

#Run the UI automation server container in STAGE environment
echo "Create test automation environment container in docker"
testSrvCont=$(sudo docker run -td -e ROOT_PASS="pass"  -p 8027:22 --name testsrvSTAGE enteezgit/casestudy:1.0)
#Retrieve the server IP address
testIP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${testSrvCont})
echo "IP of test server is:",$testIP

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
echo $testIP "ansible_ssh_pass=pass" >> hosts

echo "Hosts file is written. With following contents"
cat hosts

#following env variable disables host key checking - when not using key based authentication
export ANSIBLE_HOST_KEY_CHECKING=False

echo "Run Ansible Playbook for WEB Server host to Install Tomact"
#Run Ansible Playbook for WEB Server host to Install Tomact
ansible-playbook -i hosts -u root tomcat.yml  --extra-vars "host=$webIP $proxies"

#echo "Run Ansible Playbook for DB Server host to Install MySQL"
#Run Ansible Playbook for DB Server host to Install MySQL (this playbook should also enable remote login for the user)
#ansible-playbook -i hosts -u root mysql.yml --extra-vars "host=$dbIP mysql_root_password=pass123 $proxies"

#echo "Run Ansible Playbook for setting up MySQL DB Cluster Management Node"
ansible-playbook -i hosts -u root mgmtnode.yml --extra-vars "host=$mgmtIP dataIP1=$dataIP1 dataIP2=$dataIP2 sqlIP=$sqlIP $proxies"

#echo "Run Ansible Playbook for setting up MySQL DB Cluster Data Node 1"
ansible-playbook -i hosts -u root datanode.yml --extra-vars "host=$dataIP1 mgmtIP=$mgmtIP $proxies"

#echo "Run Ansible Playbook for setting up MySQL DB Cluster Data Node 2"
ansible-playbook -i hosts -u root datanode.yml --extra-vars "host=$dataIP2 mgmtIP=$mgmtIP $proxies"

#echo "Run Ansible Playbook for setting up MySQL DB Cluster SQL Node"
ansible-playbook -i hosts -u root sqlnode.yml --extra-vars "host=$sqlIP mgmtIP=$mgmtIP $proxies"

#echo "Run Ansible Playbook for starting up MySQL DB Cluster"
ansible-playbook -i hosts -u root startcluster.yml --extra-vars "mgmtIP=$mgmtIP dataIP1=$dataIP1 dataIP2=$dataIP2 sqlIP=$sqlIP mysql_root_password=pass123 $proxies"

echo "Changing into chef dir at:",$CHEF_REPO_WORKSPACE
#Change to CHEF REPO workspace
cd $CHEF_REPO_WORKSPACE

#Update databag
echo "Update data bag"
sed -i "s/--SVNUSER--/${svnUser}/; s/--SVNPASS--/${svnPasswd}/; s/--SVNREPO--/${svnrepodir}/" data_bags/deployprops/deploy_params.json

#Check if data bag is already created
databaglist=`knife data bag list --color -w`
if [[ $databaglist == *"deployprops"* ]]; then
    echo "Data bag exists"
else
	echo "Data will be created"
    knife data bag create deployprops
fi

#Run knife data bag command upload the databag to server
knife data bag from file deployprops data_bags/deployprops/deploy_params.json

knife node delete websrvSTAGE -y || echo "Knife node ok"

knife client delete websrvSTAGE -y || echo "Knife client ok"

echo "Run knife bootstrap command to bootstrap the websrvSTAGE server as a node"
#Run knife bootstrap command to bootstrap the websrvSTAGE server as a node
knife bootstrap $webIP -x root -P pass -N websrvSTAGE -r 'recipe[devopssvn]'  --node-ssl-verify-mode none  --bootstrap-proxy http://$svnUser:$svnPasswd@ptproxy.persistent.co.in:8080

echo "Changing into ansible dir at:",$ANSIBLE_WORKSPACE
cd $ANSIBLE_WORKSPACE

echo "Install and run the test automation suite"
ansible-playbook -i hosts -u root testsuite.yml --extra-vars "host=$testIP $proxies vmIP=10.51.238.183 port=8088 buildno=${BUILD_NUMBER}"

cd $WORKSPACE
sudo docker cp testsrvSTAGE:/root/result.txt $WORKSPACE/result.txt
sudo docker cp testsrvSTAGE:/root/test_result.log $WORKSPACE/test_result.log

#Read the number of failed cases from result.txt
testResult=`cat result.txt`

#Clean docker containers
#sudo docker kill websrvSTAGE mgmtNodeSTAGE dataNode1STAGE dataNode2STAGE sqlNodeSTAGE testsrvSTAGE || echo "Containers clean"
#sudo docker rm websrvSTAGE mgmtNodeSTAGE dataNode1STAGE dataNode2STAGE sqlNodeSTAGE testsrvSTAGE || echo "Containers clean"

#There are total 10 cases, so if all passed then build qualifies for PRODUCTION build
if [ "$testResult" -eq 0 ]
then
	echo "Execute next build"
  	exit 0
else
  	echo "Test cases failed"
  	exit 1
fi