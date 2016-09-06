FROM indigo/centos-jdk8:latest
MAINTAINER Ronny Trommer <ronny@opennms.org>

ENV OPENNMS_VERSION develop
#ENV OPENNMS_MINION_HOME /opt/minion
#ENV OPENNMS_LOCATION MINION
#ENV OPENNMS_MINION_CONFIG /opt/minion/etc/org.opennms.minion.controller.cfg
#ENV OPENNMS_BROKER_URL tcp://127.0.0.1:61616
#ENV OPENNMS_HTTP_URL tcp://127.0.0.1:8980/opennms

RUN rpm -Uvh http://yum.opennms.org/repofiles/opennms-repo-${OPENNMS_VERSION}-rhel7.noarch.rpm && \
    rpm --import http://yum.opennms.org/OPENNMS-GPG-KEY && \
    yum -y install opennms-minion

COPY ./assets/docker-entrypoint.sh /
COPY ./assets/org.apache.karaf.shell.cfg /opt/minion/etc

WORKDIR /opt/minion/bin

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "-h" ]

##------------------------------------------------------------------------------
## EXPOSED PORTS
##------------------------------------------------------------------------------
## -- OpenNMS KARAF SSH   8201/TCP
## -- OpenNMS JMX        18980/TCP
## -- SNMP Trapd           162/UDP
## -- Syslog               514/UDP
EXPOSE 8201 18980 162/udp 514/udp