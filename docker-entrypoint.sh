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
    echo "-c: Start Minion and use environment credentials to register Minion on OpenNMS."
    echo "    WARNING: Credentials can be exposed via docker inspect and log files. Please consider to use -s option."
    echo "-s: Initialize a keystore file with credentials in /keystore/scv.jce."
    echo "    Mount /keystore to your local system or a volume to save the keystore file."
    echo "    You can mount the keystore file to ${MINION_HOME}/etc/scv.jce and just use -f to start the Minion."
    echo "-f: Initialize and start OpenNMS Minion in foreground."
    echo "-h: Show this help."
    echo ""
}

useEnvCredentials(){
  echo "WARNING: Credentials can be exposed via docker inspect and log files. Please consider to use a keystore file."
  echo "         You can initialize a keystore file with the -s option."
  ${MINION_HOME}/bin/scvcli set opennms.http ${OPENNMS_HTTP_USER} ${OPENNMS_HTTP_PASS}
  ${MINION_HOME}/bin/scvcli set opennms.broker ${OPENNMS_BROKER_USER} ${OPENNMS_BROKER_PASS}
}

setCredentials() {
  # Directory to initialize a new keystore file which can be mounted to the local host
  if [ -z /keystore ]; then
    mkdir /keystore
  fi

  read -p "Enter OpenNMS HTTP username: " OPENNMS_HTTP_USER
  read -s -p "Enter OpenNMS HTTP password: " OPENNMS_HTTP_PASS
  echo ""

  read -p "Enter OpenNMS Broker username: " OPENNMS_BROKER_USER
  read -s -p "Enter OpenNMS Broker password: " OPENNMS_BROKER_PASS
  echo ""

  ${MINION_HOME}/bin/scvcli set opennms.http ${OPENNMS_HTTP_USER} ${OPENNMS_HTTP_PASS}
  ${MINION_HOME}/bin/scvcli set opennms.broker ${OPENNMS_BROKER_USER} ${OPENNMS_BROKER_PASS}

  cp ${MINION_HOME}/etc/scv.jce /keystore
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
while getopts csfh flag; do
    case ${flag} in
        c)
            useEnvCredentials
            initConfig
            start
            ;;
        s)
            setCredentials
            ;;
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
