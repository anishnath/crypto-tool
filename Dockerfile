FROM tomcat:8.0
MAINTAINER ANISH NATH zarigatongy@gmail.com
COPY ROOT.war /usr/local/tomcat/webapps/
COPY crypto.war /usr/local/tomcat/webapps/
COPY crypto.war /usr/local/tomcat/webapps/
COPY ntru.war  /usr/local/tomcat/webapps/
EXPOSE 8080/tcp