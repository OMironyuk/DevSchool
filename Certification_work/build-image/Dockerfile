FROM maven:3.8.1-jdk-8 AS build

WORKDIR /home/user/

#get app
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git

#build artifact
RUN cd /home/user/boxfuse-sample-java-war-hello/ && \
    mvn package


FROM tomcat:alpine

COPY --from=build /home/user/boxfuse-sample-java-war-hello/target/*.war /usr/local/tomcat/webapps/hello.war

