#
# Cookbook Name:: devopssvn
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "subversion"

deployprops = data_bag_item('deployprops','deploy_params')

Chef::Log.debug("User Name #{deployprops['svnusr']}")

execute "Get war file" do
    command "/usr/bin/svn co --depth=immediates --username #{deployprops['svnusr']} --password #{deployprops['svnpass']}  --no-auth-cache --non-interactive --trust-server-cert  https://svn.persistent.co.in/svn/DevOps_Compt/#{deployprops['repofolder']} /root/"
end

remote_file "Move WAR to Tomcat" do 
  source "file:///root/webapp.war" 
  path "/opt/apache-tomcat-6.0.32/webapps/webapp.war"
  owner 'root'
  group 'root'
  mode 0777
end

execute "Stop Tomcat" do
  command "sh /opt/apache-tomcat-6.0.32/bin/shutdown.sh"
end

execute "Start Tomcat" do
  command "sh /opt/apache-tomcat-6.0.32/bin/startup.sh"
end

execute "Wait for WAR deployment" do
  command "/bin/sleep 10"
end

execute "Update property file - IP address, port and username" do
  command "/bin/echo -e 'dbport=#{deployprops['port']}\ndbuser=root2\ndbpasswd=pass123\ndbhost=#{deployprops['ip']}\ndbname=devopsdb' > /opt/apache-tomcat-6.0.32/webapps/webapp/WEB-INF/classes/config.properties"
end
