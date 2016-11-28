[![Build Status](https://travis-ci.org/juju4/ansible-bind.svg?branch=master)](https://travis-ci.org/juju4/ansible-bind)
# Secure Bind ansible role

Ansible role to setup Bind/Named DNS server with sane secure default.
Including
* DNSSEC for authentication,
* RPZ to whitelist/blacklist entries
* Malware domains list blackholed
* Secure template from Team Cymru template (http://www.cymru.com/Documents/secure-bind-template.html)
Mostly as cache/forwarder but could be other roles.

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 2.0
 * 2.1
 * 2.2

### Operating systems

Tested with Ubuntu 14.04 (bind 9.9.5), 16.04(9.10.3) and centos7(9.9.4)

## Example Playbook

Just include this role in your list.
For example

```
- host: all
  roles:
    - bind
```

## Variables

Nothing specific for now.

## Continuous integration

This role has a travis basic test (for github), more advanced with kitchen and also a Vagrantfile (test/vagrant).

Once you ensured all necessary roles are present, You can test with:
```
$ cd /path/to/roles/bind
$ kitchen verify
$ kitchen login
```
or
```
$ cd /path/to/roles/bind/test/vagrant
$ vagrant up
$ vagrant ssh
```

## Troubleshooting & Known issues


## License

BSD 2-clause

