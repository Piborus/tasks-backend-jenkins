FROM tomcat:9.0.111-jdk11-temurin-noble

ARG WAR_FILE
ARG CONTEXT

COPY ${WAR_FILE} /usr/local/tomcat/webapps/${CONTEXT}.war