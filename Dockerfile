FROM indigo/centos-jdk8:latest
MAINTAINER Ronny Trommer <ronny@opennms.org>

ENV OPENNMS_VERSION develop
ENV OPENNMS_MINION_HOME /opt/minion
ENV OPENNMS_LOCATION MINION
ENV OPENNMS_MINION_CONFIG ${OPENNMS_MINION_HOME}/etc/org.opennms.minion.controller.cfg
ENV OPENNMS_MINION_CONFIG_DIR ${OPENNMS_MINION_HOME}/etc
ENV OPENNMS_BROKER_URL tcp://127.0.0.1:61616
ENV OPENNMS_HTTP_URL tcp://127.0.0.1:8980/opennms

RUN rpm -Uvh http://yum.opennms.org/repofiles/opennms-repo-${OPENNMS_VERSION}-rhel7.noarch.rpm && \
    rpm --import http://yum.opennms.org/OPENNMS-GPG-KEY && \
    yum -y install opennms-minion

WORKDIR /opt/minion/bin

ENTRYPOINT ["./karaf"]

CMD ["status"]

##------------------------------------------------------------------------------
## EXPOSED PORTS
##------------------------------------------------------------------------------
## -- OpenNMS KARAF SSH   8201/TCP
## -- OpenNMS JMX        18980/TCP
## -- SNMP Trapd           162/UDP
## -- Syslog               514/UDP
EXPOSE 8201 18980 162/udp 514/udp



location = Fulda
id = b17a11b4-741b-11e6-9c50-0242ac110003
broker-url = tcp://172.24.23.103:61616
http-url = http://172.24.23.103:8980/opennms