## Supported tags

* `latest`, latest develop release Horizon 20
* `19.0.1-1`, stable Horizon 19
* `19.0.0-1`, stable Horizon 19

### latest

* CentOS 7 with OpenJDK 8u121-jdk
* Minion 20 develop snapshot

### 19.0.1-1

* CentOS 7 with OpenJDK 8u121-jdk
* Minion 19.0.1 stable

### 19.0.0-1

* CentOS 7 with OpenJDK 8u121-jdk
* Minion 19.0.0 stable

## Minion Docker files

This repository provides OpenNMS Minions as docker images.

It is recommended to use `docker-compose` to build a service stack.
You can provide the Minion configuration in the `.minion.env` file.

## Requirements

* docker 1.11+
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

## Author

ronny@opennms.org
