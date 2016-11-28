require 'serverspec'

# Required by serverspec
set :backend, :exec

describe command('host mw077.ru') do
#  its(:stdout) { should match /has address 92.53.114.87/ }
  its(:stdout) { should match /has address 10.0.0.1/ }
end
describe command('host www.mw077.ru') do
  its(:stdout) { should match /has address 10.0.0.1/ }
end

