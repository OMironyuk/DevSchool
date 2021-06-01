FROM tomcat

RUN apt-get update && apt-get -y upgrade && apt-get -y install maven git
RUN mkdir -p /home/user/ && cd /home/user/ && git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git
RUN cd /home/user/boxfuse-sample-java-war-hello && mvn package
RUN cp /home/user/boxfuse-sample-java-war-hello/target/hello-1.0.war /usr/local/tomcat/webapps

