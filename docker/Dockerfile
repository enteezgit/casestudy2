FROM enteezgit/casestudy:1.0
MAINTAINER Niloday <enteez.git@gmail.com>

ENV http_proxy "http://carol_dcunha:msgre%402017@hjproxy.persistent.co.in:8080"
ENV https_proxy "https://carol_dcunha:msgre%402017@hjproxy.persistent.co.in:8080"

RUN wget -O /opt/apache-tomcat-6.0.32.tar.gz http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.32/bin/apache-tomcat-6.0.32.tar.gz

EXPOSE 22
EXPOSE 8080
EXPOSE 3306
EXPOSE 1186
EXPOSE 2202
CMD ["/usr/sbin/sshd", "-D"]


