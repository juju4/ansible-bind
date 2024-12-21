[![Actions Status - Master](https://github.com/juju4/ansible-bind/workflows/AnsibleCI/badge.svg)](https://github.com/juju4/ansible-bind/actions?query=branch%3Amaster)
[![Actions Status - Devel](https://github.com/juju4/ansible-bind/workflows/AnsibleCI/badge.svg?branch=devel)](https://github.com/juju4/ansible-bind/actions?query=branch%3Adevel)

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

For internal domains, be aware:
* [Reserved Top Level DNS Names, RFC2606](https://datatracker.ietf.org/doc/html/rfc2606): .test, .example, .invalid, .localhost, example.com, example.net, example.org; [Private DNS Namespaces, RFC6762](https://www.rfc-editor.org/rfc/rfc6762#appendix-G): .intranet, .internal, .private, .corp, .home, .lan
* [Approved Resolutions | Special Meeting of the ICANN Board | 29 July 2024: Reserving .INTERNAL for Private-Use Applications](https://www.icann.org/en/board-activities-and-meetings/materials/approved-resolutions-special-meeting-of-the-icann-board-29-07-2024-en#section2.a)
* [Active Directory: Best Practices for Internal Domain and Network Names](https://learn.microsoft.com/en-us/archive/technet-wiki/34981.active-directory-best-practices-for-internal-domain-and-network-names): "Microsoft strongly suggests to work with subdomains, within a publicly registered TLD domain", [Naming conventions in Active Directory for computers, domains, sites, and OUs](https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/naming-conventions-for-computer-domain-site-ou)

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 2.10-17

### Operating systems

Tested on Ubuntu 24.04 (bind 9.18.28), 22.04 (9.18.1) and centos/rockylinux 9 (9.16.23).

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
or
```
$ pip install molecule docker
$ molecule test
$ MOLECULE_DISTRO=ubuntu:24.04 molecule test --destroy=never
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
