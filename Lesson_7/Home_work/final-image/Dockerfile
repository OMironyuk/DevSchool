FROM ubuntu:21.10

# set timezone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# create catalina path
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

# install base soft
RUN apt update && \
    apt install default-jre -y && \
    rm -rf /var/cache/apt/archives/*

# get Tomcat and app from image build
WORKDIR "$CATALINA_HOME"
RUN wget -O tomcat.tar.gz "https://mirror.linux-ia64.org/apache/tomcat/tomcat-9/v9.0.46/bin/apache-tomcat-9.0.46.tar.gz" && \
    tar -xf tomcat.tar.gz --strip-components=1 && \
    rm -rf tomcat.tar.gz


# run tomcat
CMD ["catalina.sh", "run"]