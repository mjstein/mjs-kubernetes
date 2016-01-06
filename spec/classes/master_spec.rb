require 'spec_helper'

describe 'kubernetes::master' do
  context 'with normal operation' do
    describe 'with valid ips' do 
      let :params do {
        :master_name => '1.1.1.1',
        :minion_name => '1.2.1.1'
      } end
      it {should compile}
      it {should contain_class('kubernetes')}
      ['/etc/kubernetes/apiserver','/etc/kubernetes/controller-manager','/etc/etcd/etcd.conf'].each do |i|
        it {should contain_file(i)} 
      end
      ['flanneld','etcd', 'kube-apiserver', 'kube-controller-manager', 'kube-scheduler'].each do |i|
        it {should contain_service(i)}
      end
      ['docker','docker-logrotate','kubernetes','etcd', 'flannel'].each do |i|
        it {should contain_package(i)}
      end
    end
    describe 'with valid hostnames' do 
      let :params do {
        :master_name => 'master',
        :minion_name => 'minion'
      } end
      it {should compile}
    end

  end
end



