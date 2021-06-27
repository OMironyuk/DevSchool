FROM maven:3.8.1-jdk-8
WORKDIR /home/user/

#get app
RUN git clone https://github.com/OMironyuk/App42.git
#copy config file
COPY Config.properties /home/user/App42/WebContent/
#build artefact
RUN cd /home/user/App42/ && \
    mvn package
