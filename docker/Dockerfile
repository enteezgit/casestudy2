FROM ubuntu:14.04
MAINTAINER Niloday <enteez.git@gmail.com>

ENV http_proxy "http://firstname_lastname:zzzzzzzzzzzzz@hjproxy.persistent.co.in:8080"
ENV https_proxy "https://firstname_lastname:zzzzzzzzzzzzz@hjproxy.persistent.co.in:8080"

RUN apt-get update && apt-get install -y openssh-server openjdk-7-jdk 
RUN mkdir /var/run/sshd
RUN echo 'root:pass' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN wget http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.4/mysql-cluster-gpl-7.4.12-linux-glibc2.5-x86_64.tar.gz
RUN wget -O /opt/apache-tomcat-6.0.32.tar.gz http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.32/bin/apache-tomcat-6.0.32.tar.gz

EXPOSE 22
EXPOSE 8080
EXPOSE 3306
EXPOSE 1186
EXPOSE 2202
CMD ["/usr/sbin/sshd", "-D"]


