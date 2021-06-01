FROM ubuntu:21.10 AS build

# set timezone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install base soft
RUN apt update && \
    apt install default-jdk maven git wget -y

# get tomcat
WORKDIR /usr/local/tomcat
RUN wget -O tomcat.tar.gz "https://mirror.linux-ia64.org/apache/tomcat/tomcat-9/v9.0.46/bin/apache-tomcat-9.0.46.tar.gz"

# unzip tomcat
RUN tar -xf tomcat.tar.gz --strip-components=1 && \
    rm -rf tomcat.tar.gz

# get app
WORKDIR /home/user/
RUN git clone https://github.com/Artur-/Solitaire.git && \
    cd /home/user/Solitaire/ && \
    mvn package && \
    mv /home/user/Solitaire/target/*.war /home/user/Solitaire/target/solitaire.war && \
    rm -rf /home/user/Solitaire/target/![*.war]
