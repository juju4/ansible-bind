## from https://sharknet.us/2014/02/06/infrastructure-testing-with-ansible-and-serverspec-part-2/

require 'spec_helper'
require 'csv'

###################################
# All the files are installed
###################################
describe "DNS Server Infrastructure" do

    describe "Check that all configuration files are present" do
        describe file('/etc/named.conf') do
          it { should be_file }
      end

      describe file('/etc/named.rfc1912.zones') do
          it { should be_file }
      end

      describe file('/var/named/sharknet.us.zone') do
          it { should be_file }
      end

      describe file('/var/named/db.1.168.192') do
          it { should be_file }
      end

  end

  describe "Test BIND services" do
    describe package('bind-chroot') do
      it { should be_installed }
  end

  describe service("named") do
      it { should be_enabled }
      it { should be_running }
  end

  describe port(53) do
      it { should be_listening.with('udp') }
  end

  describe port(53) do
      it { should be_listening.with('tcp') }
  end
end

describe "The BIND user 'named':" do
    it "should exist" do
        expect( user('named') ).to be
    end

    it "should belong to a group called 'named'" do
        expect( user('named') ).to belong_to_group 'named'
    end
end

###################################
# DNS file syntax check
###################################

describe "Validate configuration files" do

    describe command('named-checkconf /etc/named.conf') do
      it { should return_stdout '' }
    end

    describe command('named-checkconf -t /var/named/chroot /etc/named.conf') do
      it { should return_stdout '' }
    end

    describe command('named-checkzone sharknet.us /var/named/sharknet.us.zone') do
        its(:stdout) { should include 'OK' }
    end

    describe command("named-checkzone 1.168.192.in-addr.arpa /var/named/db.1.168.192") do
        its(:stdout) { should include 'OK' }
    end

end

describe "Record Lookup" do
    before(:all) do
        @domain_name = 'sharknet.us'
            # Cache DNS servers
            @dns_servers ||= []
            @dns_servers.push( DNS.new('192.168.1.5', 'Master', @domain_name ))
            # You can add others here

            # Load DNS records from a CSV file
            @records = CSV.readlines('spec/bind/records.csv')
        end

        it "Should return the correct IP address for static hostnames (A records)" do
            @dns_servers.each do |nameserver|
                @records.each do |record|
                    if record[2] == 'A'
                        expect(nameserver.is_host?(record[0],record[1])).to be_true , "Server #{nameserver} did not find IP address #{record[1]} for #{record[0]}"
                    end
                end
            end
        end

        it "Should return the correct hostname for static IP addresses (PTR records)" do
            @dns_servers.each do |nameserver|
                @records.each do |record|
                    if record[2] == 'A'
                        expect(nameserver.is_pointer?(record[1],record[0])).to be_true , "Server #{nameserver} did not find host name #{record[0]} for #{record[1]}"
                    end
                end
            end
        end

        it "Should resolve external host names." do
            external_hosts = [
                "www.google.com",
                "www.cnn.com",
                "www.facebook.com"
            ]
            @dns_servers.each do |nameserver|
                external_hosts.each do |host|
                    ip = nameserver.address( host )
                    expect(ip).to_not eql('Hostname not found'), "Server #{nameserver} could not resolve #{host}"
                end
            end
        end

        it "Should return the correct mail servers (MX records)" do
            @dns_servers.each do |nameserver|
                @records.each do |record|
                    if record[2] == 'MX'
                        exists = nameserver.is_mail_server?( @domain_name, record[0], 10 )
                        expect(exists).to be_true, "Server #{nameserver} did have an MX record for #{record[0]}"
                    end
                end
            end
        end

        it "Should return the correct nameservers (NS records)" do
            @dns_servers.each do |nameserver|
                @records.each do |record|
                    if record[2] == 'NS'
                        exists = nameserver.is_nameserver?( @domain_name, record[0] )
                        expect(exists).to be_true, "Server #{nameserver} did have an NS record for #{record[0]}"
                    end
                end
            end
        end

        it "Should return the correct aliases (CNAME records)" do
            @dns_servers.each do |nameserver|
                @records.each do |record|
                    if record[2] == 'CNAME'
                        exists = nameserver.is_alias?( record[0], record[1] )
                        expect(exists).to be_true, "Server #{nameserver} did have a CNAME record for #{record[0]} that aliased to #{record[1]}"
                    end
                end
            end
        end

    end
end


