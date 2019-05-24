FROM opennms/openjdk:11.0.3.7-b1

LABEL maintainer "Ronny Trommer <ronny@opennms.org>"

ARG MINION_VERSION=develop

ENV MINION_HOME /opt/minion
ENV MINION_CONFIG /opt/minion/etc/org.opennms.minion.controller.cfg

ENV MINION_ID 00000000-0000-0000-0000-deadbeef0001
ENV MINION_LOCATION MINION

ENV OPENNMS_BROKER_URL tcp://127.0.0.1:61616
ENV OPENNMS_HTTP_URL http://127.0.0.1:8980/opennms

ENV OPENNMS_HTTP_USER minion
ENV OPENNMS_HTTP_PASS minion
ENV OPENNMS_BROKER_USER minion
ENV OPENNMS_BROKER_PASS minion

RUN yum -y --setopt=tsflags=nodocs update && \
    rpm -Uvh http://yum.opennms.org/repofiles/opennms-repo-${MINION_VERSION}-rhel7.noarch.rpm && \
    rpm --import http://yum.opennms.org/OPENNMS-GPG-KEY && \
    yum -y install opennms-minion && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    chown minion:minion /opt/minion && \
    sed -r -i '/RUNAS/s/.*/export RUNAS=minion/' /etc/sysconfig/minion && \
    chgrp -R 0 /opt/minion && \
    chmod -R g=u /opt/minion

USER 999

COPY ./docker-entrypoint.sh /

LABEL license="AGPLv3" \
      org.opennms.horizon.version="${MINION_VERSION}" \
      vendor="OpenNMS Community" \
      name="Minion"

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "-f" ]

##------------------------------------------------------------------------------
## EXPOSED PORTS
##------------------------------------------------------------------------------
## -- OpenNMS KARAF SSH   8201/TCP
## -- OpenNMS JMX        18980/TCP
## -- SNMP Trapd          1162/UDP
## -- Syslog              1514/UDP
EXPOSE 8201 1162/udp 1514/udp
