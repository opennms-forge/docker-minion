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
    if [ ! -d ${OPENNMS_MINION_HOME} ]; then
        echo "OpenNMS Minion home directory doesn't exist in ${OPENNMS_MINION_HOME}."
        exit ${E_ILLEGAL_ARGS}
    fi

    if [ ! -f ${OPENNMS_MINION_HOME}/etc/configured} ]; then
        sed -i "s,sshHost = 127.0.0.1,sshHost = 0.0.0.0," ${OPENNMS_MINION_HOME}/etc/org.apache.karaf.shell.cfg
        sed -i "s,location = MINION,location = ${OPENNMS_LOCATION}," ${OPENNMS_MINION_CONFIG}
        echo "broker-url = ${OPENNMS_BROKER_URL}" >> ${OPENNMS_MINION_CONFIG}
        echo "http-url = ${OPENNMS_HTTP_URL}" >> ${OPENNMS_MINION_CONFIG}
        echo "Configured $(date)" > ${OPENNMS_MINION_HOME}/etc/configured
    fi
}

start() {
    cd ${OPENNMS_MINION_HOME}/bin
    exec ./karaf clean server
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
