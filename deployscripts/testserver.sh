#!/bin/bash
svnUser=$1
svnPasswd=$2
warFile='webapp.war'
proxyuser=$3
proxypassword=$4

#Script to be called with command lines as 1- SVN UserName 2- SVN Users password 3 - ProxyUserName 4 - Proxy Password

echo "starting installation with ",$1,$2,$3,$4

#obtain proxies
proxies=$(env | grep proxy | tr '\n' ' ')

echo "Proxies obtained: "$proxies

echo "Attempting to connect to SVN Repo"
#Sync with SVN repo
svn co --username $svnUser --depth=immediates --password $svnPasswd --no-auth-cache --non-interactive --trust-server-cert  https://svn.persistent.co.in/svn/DevOps_Compt/$svnUser .

echo "Attempting to check status of war"
#Determine if the WAR file is pre-existing in the SVN repo.  If the file pre-existed in repo following command would return M
svn status | awk '$2 == "webapp.war" {print $1}'

cwd=pwd
echo "Current dir is: "`pwd`

fileStatus=`svn status | awk '$2 == "readme.txt" {print $1}'`

if [ $fileStatus != 'M' ] 
	then
        echo "Adding new file to svn"
	svn add --username $svnUser --password $svnPasswd --no-auth-cache --non-interactive --trust-server-cert warFile #Add the new file to SVN
else
        echo "Updating existing file into svn repo"
    svn update --username $svnUser --password $svnPasswd --no-auth-cache --non-interactive --trust-server-cert #Update the existing file to SVN
	fi

echo "Commiting into svn as Ready for TEST"
svn commit --username $svnUser --password $svnPasswd --no-auth-cache --non-interactive --trust-server-cert -m "Ready for TEST" #Commit the file to SVN

#Run the Web Server container in TEST environment
#sudo docker  run -td -p 8022:22 -p 8088:8080  --name websrvTEST sumedh1988/ubuntussh:14.04
echo "Create web server container in docker"
webSrvCont=$(sudo docker run -td -e ROOT_PASS="pass" -p 8022:22 -p 8088:8080 --name websrvTEST sumedh1988/ubuntussh:14.04)
#Retrieve the server IP address
webIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${webSrvCont})
echo "IP of web server is:",$webIP

#Run the database server container in TEST environment
echo "Create db server container in docker"
dbSrvCont=$(sudo docker run -td -e ROOT_PASS="pass"  -p 8023:22 -p 8306:3306 --name dbsrvTEST sumedh1988/ubuntussh:14.04)
#Retrieve the server IP address
dbIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${dbSrvCont})
echo "IP of db server is:",$dbIP

#Change to ansible workspace
echo "Changing into ansible dir at:",$ANSIBLE_WORKSPACE
cd $ANSIBLE_WORKSPACE
pwd
echo "[WebServer]" > hosts
echo $webIP  "ansible_ssh_pass=pass" >> hosts
echo "" >> hosts
 echo "[DbServer]" >> hosts
echo $dbIP  "ansible_ssh_pass=pass" >> hosts

echo "Hosts file is written. With following contents"
cat hosts

#following env variable disables host key checking - when not using key based authentication
export ANSIBLE_HOST_KEY_CHECKING=False

echo "Run Ansible Playbook for WEB Server host to Install Tomact"
#Run Ansible Playbook for WEB Server host to Install Tomact
ansible-playbook -i hosts -u root tomcat.yml  --extra-vars "host=$webIP $proxies"

echo "Run Ansible Playbook for DB Server host to Install MySQL"
#Run Ansible Playbook for DB Server host to Install MySQL (this playbook should also enable remote login for the user)
ansible-playbook -i hosts -u root mysql.yml --extra-vars "host=$dbIP mysql_root_password=pass123 $proxies"

echo "Changing into chef dir at:",$CHEF_REPO_WORKSPACE
#Change to CHEF REPO workspace
cd $CHEF_REPO_WORKSPACE
pwd
echo "Run knife client delete command"
knife client delete websrvTEST -y 
echo "Run knife client delete command"
knife node delete websrvTEST -y

echo "Run knife bootstrap command to bootstrap the websrvTEST server as a node"
#Run knife bootstrap command to bootstrap the websrvTEST server as a node
knife bootstrap $webIP -x root -P pass -N websrvTEST -r 'recipe[devopssvn]' --bootstrap-proxy http://$proxyuser:$proxypassword@ptproxy.persistent.co.in:8080

echo "Now execute UI automation tests"
#Now execute UI automation tests
echo "TODO - This is work in progress"
#TODO - run UI automation tests

echo "Go back to original working directory"
#Go back to earlier CWD
cd $cwd
pwd

#Check results
returnVal=100
if [ resultVal is >= 9 ] 
    then 
	returnVal=0
    #Following is required to force svn to identify the file as changed 
    #svn propset svn:executable ON  --username $svnUser  --password $svnPasswd --no-auth-cache --non-interactive --trust-server-cert --force warFile

    #TODO: Push war to svn with comment as "READY for STAGE"
    #svn commit --username $svnUser --password $svnPasswd --no-auth-cache --non-interactive --trust-server-cert -m "Ready for STAGE" #Commit the file to SVN
    fi

echo "Kill docker containers"
#kill docker containers
#sudo docker kill websrvTEST dbsrvTEST
echo "Remove docker containers"
#remove docker containers
#sudo docker rm websrvTEST dbsrvTEST

return returnVal
