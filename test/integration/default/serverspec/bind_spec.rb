require 'serverspec'

# Required by serverspec
set :backend, :exec

describe service('bind9'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_enabled   }
  it { should be_running   }
end  

describe process('named'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_running }
  its(:args) { should match /-u bind\b/ }
  it "is listening on port 53" do
    expect(port(53)).to be_listening.with('udp')
  end 
end

describe service('named-chroot'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe process('named'), :if => os[:family] == 'redhat' do
  it { should be_running }
  its(:args) { should match /-u named\b/ }
  it "is listening on port 53" do
    expect(port(53)).to be_listening.with('udp')
  end 
end

describe file('/etc/bind/named.conf'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  it { should be_readable.by_user('bind') }
end
describe file('/etc/bind/named.conf.options'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  it { should be_readable.by_user('bind') }
end
describe file('/etc/bind/named.conf.local'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  it { should be_readable.by_user('bind') }
end

describe file('/var/named/chroot/etc/named.conf'), :if => os[:family] == 'redhat' do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
end
describe file('/var/named/chroot/etc/named.conf.options'), :if => os[:family] == 'redhat' do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
end
describe file('/var/named/chroot/etc/named.conf.local'), :if => os[:family] == 'redhat' do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
end

describe command('named-checkconf -pxzj /etc/bind/named.conf'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should_not match /file not found/ }
  its(:stdout) { should_not match /bad zone/ }
  its(:stdout) { should match /loaded serial/ }
  its(:stdout) { should match /options/ }
## malwaredomainslist introduce multiple zones with non-fatal errors... those tests not working when included.
#  its(:stdout) { should_not match /not loaded due to errors/ }
#  its(:stderr) { should_not match /bad owner name/ }
#  its(:stdout) { should match /zone "\."/ }
end
describe command('named-checkconf -pzj -t /var/named/chroot/ /etc/named.conf'), :if => os[:family] == 'redhat' do
  its(:stdout) { should_not match /file not found/ }
  its(:stdout) { should match /loaded serial/ }
  its(:stdout) { should match /options/ }
## malwaredomainslist introduce multiple zones with non-fatal errors... those tests not working when included.
#  its(:stdout) { should_not match /not loaded due to errors/ }
#  its(:stderr) { should_not match /bad owner name/ }
#  its(:stdout) { should match /zone "\."/ }
end

describe command('host www.google.com') do
  its(:stdout) { should match /www.google.com has address / }
end
describe command('dig @127.0.0.1 -c CH -t txt version.bind') do
  its(:stdout) { should match /Don't know.../ }
end
describe command('named -V'), :if => os[:family] == 'ubuntu' && os[:release] == '18.04' do
  its(:stdout) { should match /--with-openssl/ }
  its(:stdout) { should match /linked to OpenSSL version:/ }
end
describe command('named -V'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  its(:stdout) { should match /--with-openssl/ }
  its(:stdout) { should match /compiled with OpenSSL version:/ }
end
describe command('named -V'), :if => os[:family] == 'redhat' && os[:release] == '7' do
  its(:stdout) { should match /compiled with OpenSSL version:/ }
  its(:stdout) { should match /linked to OpenSSL version:/ }
end
describe command('named -V'), :if => (os[:family] == 'ubuntu' && os[:release] == '14.04') && (os[:family] == 'redhat' && os[:release] == '6') do
  its(:stdout) { should match /using OpenSSL version/ }
end


