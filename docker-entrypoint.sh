#!/bin/bash -e
# =====================================================================
# Build script running OpenNMS Minion in Docker environment
#
# Source: https://github.com/indigo423/docker-minion
# Web: https://www.opennms.org
#
# =====================================================================

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
    if [ ! -d ${MINION_HOME} ]; then
        echo "OpenNMS Minion home directory doesn't exist in ${MINION_HOME}."
        exit ${E_ILLEGAL_ARGS}
    fi

    if [ ! -f ${MINION_HOME}/etc/configured} ]; then

        # Expose Karaf Shell
        sed -i "s,sshHost = 127.0.0.1,sshHost = 0.0.0.0," ${MINION_HOME}/etc/org.apache.karaf.shell.cfg

        # Expose the RMI registry and server
        sed -i "s,rmiRegistryHost.*,rmiRegistryHost=0.0.0.0,g" ${MINION_HOME}/etc/org.apache.karaf.management.cfg
        sed -i "s,rmiServerHost.*,rmiServerHost=0.0.0.0,g" ${MINION_HOME}/etc/org.apache.karaf.management.cfg

        # Set Minion location and connection to OpenNMS instance
        echo "location = ${MINION_LOCATION}" > ${MINION_CONFIG}
        echo "id = ${MINION_ID}" >> ${MINION_CONFIG}
        echo "broker-url = ${OPENNMS_BROKER_URL}" >> ${MINION_CONFIG}
        echo "http-url = ${OPENNMS_HTTP_URL}" >> ${MINION_CONFIG}

        echo "Configured $(date)" > ${MINION_HOME}/etc/configured
    else
        echo "OpenNMS Minion is already configured, skipped."
    fi
}

start() {
    cd ${MINION_HOME}/bin
    ./karaf server
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
