#!/bin/bash -e
# =====================================================================
# Build script running OpenNMS Minion in Docker environment
#
# Source: https://github.com/indigo423/docker-minion
# Web: https://www.opennms.org
#
# =====================================================================

START_DELAY=5

# Error codes
E_ILLEGAL_ARGS=126

# Help function used in error messages and -h option
usage() {
    echo ""
    echo "Docker entry script for OpenNMS Minion service container"
    echo ""
    echo "-f: Initialize and start OpenNMS Minion in foreground."
    echo "-h: Show this help."
    echo ""
}

initConfig() {
    if [ ! -d /opt/minion ]; then
        echo "OpenNMS Minion home directory doesn't exist in /opt/minion."
        exit ${E_ILLEGAL_ARGS}
    fi

    if [ ! -f /opt/minion/etc/configured} ]; then
        sed -i "s,sshHost = 127.0.0.1,sshHost = 0.0.0.0," /opt/minion/etc/org.apache.karaf.shell.cfg
        sed -i "s,location = MINION,location = ${OPENNMS_LOCATION}," /opt/minion/etc/org.opennms.minion.controller.cfg
        echo "broker-url = ${OPENNMS_BROKER_URL}" >> /opt/minion/etc/org.opennms.minion.controller.cfg
        echo "http-url = ${OPENNMS_HTTP_URL}" >> /opt/minion/etc/org.opennms.minion.controller.cfg
        echo "Configured $(date)" > /opt/minion/etc/configured
    fi
}

start() {
    cd /opt/minion/bin
    exec ./start
}

# Evaluate arguments for build script.
if [[ "${#}" == 0 ]]; then
    usage
    exit ${E_ILLEGAL_ARGS}
fi

# Evaluate arguments for build script.
while getopts fhis flag; do
    case ${flag} in
        f)
            initConfig
            start
            exit
            ;;
        h)
            usage
            exit
            ;;
        *)
            usage
            exit ${E_ILLEGAL_ARGS}
            ;;
    esac
done

# Strip of all remaining arguments
shift $((OPTIND - 1));

# Check if there are remaining arguments
if [[ "${#}" > 0 ]]; then
    echo "Error: To many arguments: ${*}."
    usage
    exit ${E_ILLEGAL_ARGS}
fi
