FROM arm32v7/openjdk:8-jre-slim

LABEL maintainer "Ronny Trommer <ronny@opennms.org>"

ARG MINION_VERSION=21.0.3
ARG MINION_URL=https://github.com/OpenNMS/opennms/releases/download/opennms-${MINION_VERSION}-1/minion-${MINION_VERSION}.tar.gz

ENV MINION_HOME /opt/minion
ENV MINION_LOCATION MINION
ENV MINION_CONFIG ${MINION_HOME}/etc/org.opennms.minion.controller.cfg
ENV MINION_ID 00000000-0000-0000-0000-deadbeef0001
ENV OPENNMS_BROKER_URL tcp://127.0.0.1:61616
ENV OPENNMS_HTTP_URL http://127.0.0.1:8980/opennms

RUN apt-get update && \
    apt-get -y install curl && \
    mkdir ${MINION_HOME} && \
    curl -L ${MINION_URL} | tar xz -C /opt/minion --strip-components=1

COPY ./docker-entrypoint.sh /

VOLUME [ "/opt/minion/etc", "/opt/minion/data" ]

LABEL license="AGPLv3" \
      org.opennms.horizon.version="${MINION_VERSION}" \
      vendor="OpenNMS Community" \
      name="Minion arm32v7"

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
