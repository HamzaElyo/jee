FROM quay.io/wildfly/wildfly:27.0.1.Final-jdk19
COPY target/iotplatform.war /opt/jboss/wildfly/standalone/deployments/
EXPOSE 8080
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
