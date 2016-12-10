require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/etc/bind/db.int.example.com.zone'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  it { should be_readable.by_user('bind') }
end
describe file('/etc/bind/db.rev.0.1.10.in-addr.arpa.zone'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  it { should be_readable.by_user('bind') }
end

describe command('named-checkzone int.example.com /etc/bind/db.int.example.com.zone'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should include 'OK' }
end
describe command('named-checkzone 0.1.10.in-addr.arpa /etc/bind/db.rev.0.1.10.in-addr.arpa.zone'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should include 'OK' }
end

describe file('/var/named/chroot/etc/db.int.example.com.zone'), :if => os[:family] == 'redhat' do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
end
describe file('/var/named/chroot/etc/db.rev.0.1.10.in-addr.arpa.zone'), :if => os[:family] == 'redhat' do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
end

describe command('named-checkzone int.example.com /var/named/chroot/etc/db.int.example.com.zone'), :if => os[:family] == 'redhat' do
  its(:stdout) { should include 'OK' }
end
describe command('named-checkzone 0.1.10.in-addr.arpa /var/named/chroot/etc/db.rev.0.1.10.in-addr.arpa.zone'), :if => os[:family] == 'redhat' do
  its(:stdout) { should include 'OK' }
end


describe command('host int.example.com') do
  its(:stdout) { should match /int.example.com has address 127.0.0.1/ }
end
describe command('host www.int.example.com') do
  its(:stdout) { should match /www.int.example.com has address 10.1.0.100/ }
end

describe command('host ns1.int.example.com') do
  its(:stdout) { should match /ns1.int.example.com is an alias for default-zones-/ }
  its(:stdout) { should match /10.1.0.2/ }
end
describe command('host ns2.int.example.com') do
  its(:stdout) { should match /ns2.int.example.com has address 10.1.0.3/ }
end
describe command('host smtp.int.example.com') do
  its(:stdout) { should match /smtp.int.example.com is an alias for mail.int.example.com./ }
  its(:stdout) { should match /127.0.0.1/ }
end
describe command('host proxy.int.example.com') do
  its(:stdout) { should match /proxy.int.example.com has address 10.1.0.11/ }
end

describe command('host 10.1.0.3') do
  its(:stdout) { should match /3.0.1.10.in-addr.arpa domain name pointer ns2.int.example.com/ }
end
describe command('host 10.1.0.11') do
  its(:stdout) { should match /11.0.1.10.in-addr.arpa domain name pointer proxy.int.example.com/ }
end
describe command('dig +noall +answer -x 10.1.0.11') do
  its(:stdout) { should match /11.0.1.10.in-addr.arpa.\s*604800\s*IN\s*PTR\s*proxy.int.example.com./ }
end

describe command('host lab.example.com') do
  its(:stdout) { should match /lab.example.com has address 127.0.0.1/ }
end
describe command('host ns.lab.example.com') do
  its(:stdout) { should match /ns.lab.example.com has address 10.2.0.10/ }
end
describe command('host www.lab.example.com') do
  its(:stdout) { should match /www.lab.example.com has address 10.2.0.100/ }
end

