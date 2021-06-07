FROM ubuntu:21.10 AS build

# set timezone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install base soft
RUN apt update && \
    apt upgrade -y && \
    apt install default-jdk maven git wget -y

# get app
WORKDIR /home/user/
RUN git clone https://github.com/Artur-/Solitaire.git && \
    cd /home/user/Solitaire/ && \
    mvn package

FROM tomcat:alpine

COPY --from=build /home/user/Solitaire/target/*.war /usr/local/tomcat/webapps/solitaire.war

