FROM indigo/centos-jdk8:latest
MAINTAINER Ronny Trommer <ronny@opennms.org>

ENV MINION_VERSION develop
ENV MINION_HOME /opt/minion
ENV MINION_LOCATION MINION
ENV MINION_CONFIG /opt/minion/etc/org.opennms.minion.controller.cfg
ENV OPENNMS_BROKER_URL tcp://127.0.0.1:61616
ENV OPENNMS_HTTP_URL http://127.0.0.1:8980/opennms

RUN rpm -Uvh http://yum.opennms.org/repofiles/opennms-repo-${MINION_VERSION}-rhel7.noarch.rpm && \
    rpm --import http://yum.opennms.org/OPENNMS-GPG-KEY && \
    yum -y install opennms-minion

COPY ./docker-entrypoint.sh /

VOLUME [ "/opt/minion/etc", "/opt/minion/data" ]

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