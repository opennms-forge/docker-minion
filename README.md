## Supported tags

* `drift`, bleeding edge feature release of Horizon Minion 22 with features develop in the [Drift project](https://wiki.opennms.org/wiki/DevProjects/Drift)
* `bleeding`, daily bleeding edge version of Horizon Minion 22 using OpenJDK 8u161-jdk
* `21.0.5-1`, `latest` is a reference to last stable release of Horizon Minion using OpenJDK 8u161-jdk
* `21.0.4-1`, using OpenJDK 8u161-jdk
* `21.0.3-1`, using OpenJDK 8u161-jdk
* `21.0.2-1`, using OpenJDK 8u161-jdk
* `21.0.1-1`, using OpenJDK 8u151-jdk
* `21.0.0-1`, using OpenJDK 8u151-jdk
* `20.1.0-1`, using OpenJDK 8u144-jdk
* `20.0.2-1`, using OpenJDK 8u144-jdk
* `20.0.1-1`, using OpenJDK 8u131-jdk
* `20.0.0-1`, using OpenJDK 8u131-jdk
* `19.1.0-1`, using OpenJDK 8u131-jdk
* `19.0.1-1`, using OpenJDK 8u121-jdk
* `19.0.0-1`, using OpenJDK 8u121-jdk

## General Project Information

* CI/CD Status: [![CircleCI](https://circleci.com/gh/opennms-forge/docker-minion.svg?style=svg)](https://circleci.com/gh/opennms-forge/docker-minion)
* Container Image Info: [![](https://images.microbadger.com/badges/version/opennms/minion.svg)](https://microbadger.com/images/opennms/minion "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/opennms/minion.svg)](https://microbadger.com/images/opennms/minion "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/license/opennms/minion.svg)](https://microbadger.com/images/opennms/minion "Get your own license badge on microbadger.com")
* CI/CD System: [CircleCI]
* Docker Container Image Repository: [DockerHub]
* Issue- and Bug-Tracking: [GitHub issue]
* Source code: [GitHub]
* Chat: [IRC] or [Web Chat]
* Maintainer: ronny@opennms.org

## Minion Docker files

This repository provides OpenNMS Minions as docker images.

It is recommended to use `docker-compose` to build a service stack.
You can provide the Minion configuration in the `.minion.env` file.

## Requirements

* docker 17.03+
* docker-compose 1.8.0+
* git
* optional on MacOSX, Docker environment, e.g. Kitematic, boot2docker or similar

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
Please change immediately the default password to a secure password described in the [Admin Guide](http://docs.opennms.org/opennms/branches/release-19.0.0/guide-install/guide-install.html#gi-minion).

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
It is possible to start a Minion with a given keystore file by using a file mount into the container like `-v path/to/scv.jce:/opt/minion/etc/scv.jce`

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

## Support and Issues

Please open issues in the [GitHub issue](https://github.com/opennms-forge/docker-minion) section.

[GitHub]: https://github.com/opennms-forge/docker-minion.git
[DockerHub]: https://hub.docker.com/r/opennms/minion
[GitHub issue]: https://github.com/opennms-forge/docker-minion
[CircleCI]: https://circleci.com/gh/opennms-forge/docker-minion
[Web Chat]: https://chats.opennms.org/opennms-discuss
[IRC]: irc://freenode.org/#opennms
