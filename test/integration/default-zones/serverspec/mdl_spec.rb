require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/etc/bind/spywaredomains.zones'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:content) { should match /Please visit www.malwaredomains.com for more information and to report/ }
  its(:content) { should match /{type master; file "\/etc\/bind\/blockeddomain.hosts";};/ }
  its(:content) { should match /surico.ru/ }
end
describe file('/var/named/chroot/etc/spywaredomains.zones'), :if => os[:family] == 'redhat' do
  its(:content) { should match /Please visit www.malwaredomains.com for more information and to report/ }
  its(:content) { should match /{type master; file "\/etc\/bind\/blockeddomain.hosts";};/ }
  its(:content) { should match /surico.ru/ }
end

## must reflect current mdl spywaredomains...
describe command('host bakuzbuq.ru') do
  its(:stdout) { should match /has address 10.0.0.1/ }
end
describe command('host www.bakuzbuq.ru') do
  its(:stdout) { should match /has address 10.0.0.1/ }
end

