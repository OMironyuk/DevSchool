FROM ubuntu:21.10

# set timezone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install base soft
RUN apt update && \
    apt install default-jdk maven git -y

# get app
WORKDIR /home/user/
RUN git clone https://github.com/Artur-/Solitaire.git && \
    cd /home/user/Solitaire/ && \
    mvn package && \
    mv /home/user/Solitaire/target/*.war /home/user/Solitaire/target/solitaire.war && \
    find /home/user/Solitaire/target/* ! -name *.war -delete
