# DEPRECATION of this repository

This repository is deprecated.
We have moved the build code into the [OpenNMS repository](https://github.com/OpenNMS/opennms/tree/develop/opennms-container/minion).
The publish and build workflow is now integrated as part of our CI/CD workflow.

We will archive this repository with Horizon 25 and will no longer maintain this repository.

## General Project Information

* Docker Container Image Repository: [DockerHub]
* Issue- and Bug-Tracking: [JIRA]
* Source code: [GitHub]
* Chat: [Web Chat]

## Supported tags

* `bleeding`, daily bleeding edge version of Horizon Minion 24 using OpenJDK 8u191-jdk
* `24.1.0-1`, `latest` is a reference to last stable release of Horizon Minion using OpenJDK 8u191-jdk

## Minion Docker files

This repository provides OpenNMS Minions as docker images.

It is recommended to use `docker-compose` to build a service stack.
You can provide the Minion configuration in the `.minion.env` file.

## Requirements

* A current docker environment with docker-compose
* git

## Usage

```
git clone https://github.com/opennms-forge/docker-minion.git
cd docker-minion
docker-compose up -d
```

The Karaf Shell is exposed on TCP port 8980.
Additionally the ports to receive Syslog (514/UDP) and SNMP Traps (162/UDP) are exposed as well.

To start the Minion and initialize the configuration run with argument `-f`.

You can login with default user *admin* with password *admin*.
Please change immediately the default password to a secure password described in the [Install Guide].

## Basic Environment Variables

* `MINION_ID`, the Minion ID
* `MINION_LOCATION`, the Minion Location
* `OPENNMS_HTTP_URL`, the OpenNMS WebUI Base URL
* `OPENNMS_HTTP_USER`, the user name for the OpenNMS ReST API
* `OPENNMS_HTTP_PASS`, the password for the OpenNMS ReST API
* `OPENNMS_BROKER_URL`, the ActiveMQ URL
* `OPENNMS_BROKER_USER`, the username for ActiveMQ authentication
* `OPENNMS_BROKER_PASS`, the password for ActiveMQ authentication

## Advanced Environment Variables

Kafka and UDP listeners can be configured through environment variables.
All the valid configuration entries are valid and will be processed on demand, depending on a given environment variable prefix:

* `KAFKA_RPC_`, to denote a Kafka setting for RPC
* `KAFKA_SINK_`, to denote a Kafka setting for Sink
* `UDP_`, to denote a UDP listener

### Enable Kafka for RPC (requires Horizon 23 or newer)

A sample configuration would be:

```
KAFKA_RPC_BOOTSTRAP_SERVERS=kafka_server_01:9092
KAFKA_RPC_ACKS=1
```

The above will instruct the bootstrap script to create a file called `$MINION_HOME/etc/org.opennms.core.ipc.rpc.kafka.cfg` with the following content:

```
bootstrap.servers=kafka_server_01:9092
acks=1
```

As you can see, after the prefix, you specify the name of the variable, and the underscore character will be replaced with a dot.

### Enable Kafka for Sink

A sample configuration would be:

```
KAFKA_SINK_BOOTSTRAP_SERVERS=kafka_server_01:9092
```

A similar behavior happens to populate `$MINION_HOME/etc/org.opennms.core.ipc.sink.kafka.cfg`.

### UDP Listeners

In this case, the environment variable includes the UDP port, that will be used for the configuration file name, and the properties that follow the same behavor like Kafka.
For example:

```
UDP_50001_NAME=NX-OS
UDP_50001_CLASS_NAME=org.opennms.netmgt.telemetry.listeners.udp.UdpListener
UDP_50001_LISTENER_PORT=50001
UDP_50001_HOST=0.0.0.0
UDP_50001_MAX_PACKET_SIZE=16192
```

The above will instruct the bootstrap script to create a file called `$MINION_HOME/etc/org.opennms.features.telemetry.listeners-udp-50001.cfg` with the following content:

```
name=NXOS
class-name=org.opennms.netmgt.telemetry.listeners.udp.UdpListener
listener.port=50001
maxPacketSize=16192
```

Note: `CLASS_NAME` and `MAX_PACKET_SIZE` are special cases and will be translated properly.

## Run as root or non-root

By default, Minion will run using the default `minion` user (uid: 999, gid: 997).
For this reason, if executing ICMP requests from the Minion are required, you need to specify a special kernel flag when executing `docker run`, or when using this image through `docker-compose`.
The option in question is:

```
net.ipv4.ping_group_range=0 429496729
```

For `docker run`, the syntax is:

```
docker run --sysctl "net.ipv4.ping_group_range=0 429496729" --rm --name minion -it
 -e MINION_LOCATION=Apex \
 -e OPENNMS_BROKER_URL=tcp://192.168.205.1:61616 \
 -e OPENNMS_HTTP_URL=http://192.168.205.1:8980/opennms \
 opennms/minion:bleeding -f
```

For  `docker-compose`, the syntax is:

```
version: '2.3'
services:
    minion:
        image: opennms/minion:bleeding
        environment:
          - MINION_LOCATION=Apex
          - OPENNMS_BROKER_URL=tcp://192.168.205.1:61616
          - OPENNMS_HTTP_URL=http://192.168.205.1:8980/opennms
        command: ["-f"]
        sysctls:
          - net.ipv4.ping_group_range=0 429496729
```

Another alternative to avoid providing the custom `sysctl` attribute is by running the image as root.
This can be done by passing `--user 0` to `docker run`, or by adding `user: root` on your docker-compose's yaml file.

## Dealing with Credentials

To communicate with OpenNMS credentials for the message broker and the ReST API are required.
There are two options to set those credentials to communicate with OpenNMS.

***Option 1***: Set the credentials with an environment variable

It is possible to set communication credentials with environment variables and using the `-c` option for the entrypoint.

```
docker run --rm -d \
  -e "MINION_LOCATION=Apex-Office" \
  -e "OPENNMS_BROKER_URL=tcp://172.20.11.19:61616" \
  -e "OPENNMS_HTTP_URL=http://172.20.11.19:8980/opennms" \
  -e "OPENNMS_HTTP_USER=minion" \
  -e "OPENNMS_HTTP_PASS=minion" \
  -e "OPENNMS_BROKER_USER=minion" \
  -e "OPENNMS_BROKER_PASS=minion" \
  opennms/minion -c
```

*IMPORTANT:* Be aware these credentials can be exposed in log files and the `docker inspect` command.
               It is recommended to use an encrypted keystore file which is described in option 2.

***Option 2***: Initialize and use a keystore file

Credentials for the OpenNMS communication can be stored in an encrypted keystore file `scv.jce`.
It is possible to start a Minion with a given keystore file by using a file mount into the container like `-v path/to/scv.jce:/opt/minion/etc/scv.jce`.

You can initialize a keystore file on your local system using the `-s` option on the Minion container using the interactive mode.

The following example creates a new keystore file `scv.jce` in your current working directory:

```
docker run --rm -it -v $(pwd):/keystore opennms/minion -s

Enter OpenNMS HTTP username: myminion
Enter OpenNMS HTTP password:
Enter OpenNMS Broker username: myminion
Enter OpenNMS Broker password:
[main] INFO org.opennms.features.scv.jceks.JCEKSSecureCredentialsVault - No existing keystore found at: {}. Using empty keystore.
[main] INFO org.opennms.features.scv.jceks.JCEKSSecureCredentialsVault - Loading existing keystore from: scv.jce
```

The keystore file can be used by mounting the file into the container and start the Minion application with `-f`.

```
docker run --rm -d \
  -e "MINION_LOCATION=Apex-Office" \
  -e "OPENNMS_BROKER_URL=tcp://172.20.11.19:61616" \
  -e "OPENNMS_HTTP_URL=http://172.20.11.19:8980/opennms" \
  -v $(pwd)/scv.jce:/opt/minion/etc/scv.jce \
  opennms/minion -f
```

## Using etc-overlay for custom configuration

If you just want to maintain custom configuration files outside of Minion, you can use an etc-overlay directory.
All files in this directory are just copied into /opt/minion/etc in the running container.
You can just mount a local directory like this:

```yml
volumes:
  - ./etc-overlay:/opt/minion-etc-overlay
```

[GitHub]: https://github.com/OpenNMS/opennms/tree/develop/opennms-container/minion
[DockerHub]: https://hub.docker.com/r/opennms/minion
[JIRA]: https://issues.opennms.org
[Web Chat]: https://chats.opennms.org/opennms-discuss
