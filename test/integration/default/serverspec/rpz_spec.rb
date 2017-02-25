require 'serverspec'

# Required by serverspec
set :backend, :exec

describe command('named-checkzone local.rpz /etc/bind/local.rpz.zone'), :if => os[:family] == 'ubuntu' do
  its(:stdout) { should match /zone local.rpz\/IN/ }
  its(:stdout) { should match /OK/ }
end
describe command('named-checkzone -t /var/named/chroot local.rpz /etc/local.rpz.zone'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /zone local.rpz\/IN/ }
  its(:stdout) { should match /OK/ }
end

describe command('host nastynasty.com') do
#  its(:stdout) { should match /not found: 3\(NXDOMAIN\)/ }
  its(:stdout) { should match /has address 10.0.0.1/ }
end
describe command('dig -t a +short nastynasty.com @127.0.01') do
  its(:stdout) { should match /10.0.0.1/ }
end
describe command('host softthrifty.com') do
  its(:stdout) { should match /has address 10.0.0.1/ }
end
describe command('dig -t a +short softthrifty.com @127.0.01') do
  its(:stdout) { should match /10.0.0.1/ }
end
describe command('host 32.46.21.156') do
  its(:stdout) { should match /not found: 3\(NXDOMAIN\)/ }
end
describe command('host register.science') do
  its(:stdout) { should match /has address 10.0.0.1/ }
end

