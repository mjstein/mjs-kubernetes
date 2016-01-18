load 'test/serverspec_helper.rb'
describe package('httpd'), :if => os[:family] == 'redhat' do
    it { should be_installed }
end

