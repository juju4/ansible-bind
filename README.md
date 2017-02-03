[![Build Status - Master](https://travis-ci.org/juju4/ansible-bind.svg?branch=master)](https://travis-ci.org/juju4/ansible-bind)
[![Build Status - Devel](https://travis-ci.org/juju4/ansible-bind.svg?branch=devel)](https://travis-ci.org/juju4/ansible-bind/branches)
# Secure Bind ansible role

Ansible role to setup Bind/Named DNS server with sane secure default.
Including
* Secure template from Team Cymru template (http://www.cymru.com/Documents/secure-bind-template.html).
Please note than separated internal/external views are not implemented currently.
* DNSSEC for authentication,
* RPZ to whitelist/blacklist entries
* Malware domains list blackholed
* Eventual integration with MISP RPZ export
* Authoritative DNS (mostly for internal zones)
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
    - juju4.bind
```

## Variables

Nothing specific for now.

## Continuous integration

This role has a travis basic test (for github), more advanced with kitchen and also a Vagrantfile (test/vagrant).

Once you ensured all necessary roles are present, You can test with:
```
$ cd /path/to/roles/juju4.bind
$ kitchen verify
$ kitchen login
```
or
```
$ cd /path/to/roles/juju4.bind/test/vagrant
$ vagrant up
$ vagrant ssh
```

## Troubleshooting & Known issues


## License

BSD 2-clause

## Thanks

* To bertvv for his bind ansible role for authoritative DNS with nice jinja2 filters to handle reverse lookup
https://github.com/bertvv/ansible-role-bind
In the end, there is an existing filter to do that since 1.9 ```ipaddr('revdns')```
https://docs.ansible.com/ansible/playbooks_filters_ipaddr.html
One limitation, it's for not fit for zone and as such IPv6 is untested/unsupported.



