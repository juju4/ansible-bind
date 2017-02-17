require 'serverspec'

# Required by serverspec
set :backend, :exec

## must reflect current mdl spywaredomains...
describe command('host bakuzbuq.ru') do
#  its(:stdout) { should match /has address 92.53.114.87/ }
  its(:stdout) { should match /has address 10.0.0.1/ }
end
describe command('host www.bakuzbuq.ru') do
  its(:stdout) { should match /has address 10.0.0.1/ }
end

