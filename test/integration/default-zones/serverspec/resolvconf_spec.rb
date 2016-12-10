require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/etc/resolv.conf') do
  its(:content) { should match /nameserver 127.0.0.1/ }
end
