FROM ubuntu:21.10 AS build

# set timezone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# create catalina path
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"

# install base soft
RUN apt update && \
    apt upgrade -y && \
    apt install default-jdk maven git wget -y

# get tomcat
WORKDIR "$CATALINA_HOME"
RUN wget -O tomcat.tar.gz "https://mirror.linux-ia64.org/apache/tomcat/tomcat-9/v9.0.46/bin/apache-tomcat-9.0.46.tar.gz"

# unzip tomcat
RUN tar -xf tomcat.tar.gz --strip-components=1 && \
    rm -rf tomcat.tar.gz

# get app
RUN mkdir -p /home/user/ && \
    cd /home/user/ && \
    git clone https://github.com/Artur-/Solitaire.git && \
    cd /home/user/Solitaire/ && \
    mvn packageАш

FROM tomcat:alpine

COPY --from=build /home/user/Solitaire/target/*.war /usr/local/tomcat/webapps/solitaire.war

