require 'serverspec'

# Required by serverspec
set :backend, :exec

## flags:
##	ad = Authenticated Data (ad)
##	DNSSEC OK (do) flag indicating the recursive server is DNSSEC-aware


## https://wiki.debian.org/DNSSEC

describe command('dig org. SOA +dnssec') do
#  its(:stdout) { should match /ad/ }
  its(:stdout) { should match /flags: do/ }
  its(:stdout) { should match /RRSIG/ }
end
describe command('dig com. SOA +dnssec') do
#  its(:stdout) { should match /ad/ }
  its(:stdout) { should match /flags: do/ }
  its(:stdout) { should match /RRSIG/ }
end

#describe command('dig +short test.dnssec-or-not.net TXT | tail -1') do
#  its(:stdout) { should match /Yes, you are using DNSSEC/ }
#end

#describe command('dig +noall +comments dnssec-failed.org') do
#  its(:stdout) { should match /status: SERVFAIL,/ }
#end

##  https://docs.menandmice.com/display/MM/How+to+test+DNSSEC+validation

describe command('dig pir.org +dnssec +multi') do
#  its(:stdout) { should match /ad/ }
  its(:stdout) { should match /flags: do/ }
  its(:stdout) { should match /RRSIG/ }
end

## https://users.isc.org/~jreed/dnssec-guide/dnssec-guide.html

describe command('dig www.isc.org. A +dnssec +multiline') do
  its(:stdout) { should match /ad/ }
  its(:stdout) { should match /flags: do/ }
  its(:stdout) { should match /RRSIG/ }
end

describe command('delv  www.isc.org. A +rtrace'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  its(:stdout) { should match /fully validated/ }
  its(:stdout) { should_not match /resolution failed: no valid DS/ }
end

describe command('drill -S isc.org'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /DNSKEY/ }
  its(:stdout) { should_not match /<no data>/ }
end

describe command('dig www.cloudflare.com. A +dnssec +multiline') do
#  its(:stdout) { should match /ad/ }
  its(:stdout) { should match /flags: do/ }
  its(:stdout) { should match /RRSIG/ }
end

describe command('delv  www.cloudflare.com. A +rtrace'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  its(:stdout) { should match /fully validated/ }
  its(:stdout) { should_not match /resolution failed: no valid DS/ }
end

describe command('drill -S cloudflare.com'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /DNSKEY/ }
  its(:stdout) { should_not match /<no data>/ }
end

describe command('dig www.freebsd.org. A +dnssec +multiline') do
#  its(:stdout) { should match /ad/ }
  its(:stdout) { should match /flags: do/ }
  its(:stdout) { should match /RRSIG/ }
end

describe command('delv  www.freebsd.org. A +rtrace'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  its(:stdout) { should match /fully validated/ }
  its(:stdout) { should_not match /resolution failed: no valid DS/ }
end

describe command('drill -S www.freebsd.org'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /DNSKEY/ }
  its(:stdout) { should_not match /<no data>/ }
end


