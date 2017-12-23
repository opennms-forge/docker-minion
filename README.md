## Supported tags

* `drift`, bleeding edge feature release of Horizon Minion 22 with features develop in the [Drift project](https://wiki.opennms.org/wiki/DevProjects/Drift)
* `bleeding`, daily bleeding edge version of Horizon Minion 22 using OpenJDK 8u151-jdk
* `21.0.2-1`, `latest` is a reference to last stable release of Horizon Minion using OpenJDK 8u151-jdk
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

## Support and Issues

Please open issues in the [GitHub issue](https://github.com/opennms-forge/docker-minion) section.

[GitHub]: https://github.com/opennms-forge/docker-minion.git
[DockerHub]: https://hub.docker.com/r/opennms/minion
[GitHub issue]: https://github.com/opennms-forge/docker-minion
[CircleCI]: https://circleci.com/gh/opennms-forge/docker-minion
[Web Chat]: https://chats.opennms.org/opennms-discuss
[IRC]: irc://freenode.org/#opennms


