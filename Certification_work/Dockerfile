FROM maven:3.8.1-jdk-8 AS build

WORKDIR /home/user/

#get source project
RUN git clone https://github.com/ranuraag/sudokusolver.git

#build artifact
RUN cd /home/user/sudokusolver/ && \
    mvn package

FROM tomcat:alpine

COPY --from=build /home/user/sudokusolver/target/*.war /usr/local/tomcat/webapps/

