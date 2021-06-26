FROM maven:3.2.5-jdk-6
WORKDIR /home/user/

#get app
RUN git clone https://github.com/shephertz/App42PaaS-Java-MySQL-Sample.git
#copy config file
COPY Config.properties /home/user/App42PaaS-Java-MySQL-Sample/WebContent/
#build artefact
RUN cd /home/user/App42PaaS-Java-MySQL-Sample/ && \
    mvn package
