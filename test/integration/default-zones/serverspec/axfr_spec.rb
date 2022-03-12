require 'serverspec'

# Required by serverspec
set :backend, :exec


describe command('dig axfr @127.0.0.1 int.example.com') do
  its(:stdout) { should match /; Transfer failed./ }
end
describe command('dig axfr @127.0.0.1 lab.example.com') do
  its(:stdout) { should match /; Transfer failed./ }
end
describe command('dig axfr @127.0.0.1 0.1.10.in-addr.arpa') do
  its(:stdout) { should match /; Transfer failed./ }
end
