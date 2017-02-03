#!/bin/sh
## one script to be used by travis, jenkins, packer...

umask 022

rolesdir=$(dirname $0)/..

#[ ! -d $rolesdir/juju4.redhat-epel ] && git clone https://github.com/juju4/ansible-redhat-epel $rolesdir/juju4.redhat-epel
## galaxy naming: kitchen fails to transfer symlink folder
#[ ! -e $rolesdir/juju4.bind ] && ln -s ansible-bind $rolesdir/juju4.bind
[ ! -e $rolesdir/juju4.bind ] && cp -R $rolesdir/ansible-bind $rolesdir/juju4.bind

## don't stop build on this script return code
true

