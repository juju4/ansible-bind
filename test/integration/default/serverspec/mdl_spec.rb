require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/etc/bind/spywaredomains.zones') do
  its(:content) { should match /Please visit www.malwaredomains.com for more information and to report/ }
  its(:content) { should match /{type master; file "\/etc\/bind\/blockeddomain.hosts";};/ }
  its(:content) { should match /surico.ru/ }
end

describe command('host surico.ru') do
  its(:stdout) { should match /has address 10.0.0.1/ }
end
describe command('host www.surico.ru') do
  its(:stdout) { should match /has address 10.0.0.1/ }
end

