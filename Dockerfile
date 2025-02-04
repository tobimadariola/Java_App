FROM tomcat
COPY ./target/hello-world.war /usr/local/tomcat/webapps
EXPOSE 4000

