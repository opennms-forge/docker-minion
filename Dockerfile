FROM opennms/openjdk:8u131-jdk

MAINTAINER Ronny Trommer <ronny@opennms.org>

ARG MINION_VERSION=stable

ENV MINION_HOME /opt/minion
ENV MINION_LOCATION MINION
ENV MINION_CONFIG /opt/minion/etc/org.opennms.minion.controller.cfg
ENV MINION_ID 00000000-0000-0000-0000-deadbeef0001
ENV OPENNMS_BROKER_URL tcp://127.0.0.1:61616
ENV OPENNMS_HTTP_URL http://127.0.0.1:8980/opennms

RUN yum -y --setopt=tsflags=nodocs update && \
    rpm -Uvh http://yum.opennms.org/repofiles/opennms-repo-${MINION_VERSION}-rhel7.noarch.rpm && \
    rpm --import http://yum.opennms.org/OPENNMS-GPG-KEY && \
    yum -y install opennms-minion && \
    yum clean all

COPY ./docker-entrypoint.sh /

VOLUME [ "/opt/minion/etc", "/opt/minion/data" ]

HEALTHCHECK --interval=10s --timeout=3s CMD /opt/minion/bin/client ping | grep -Pzo "(?s).*OK.*.OK.*" || exit 1

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
