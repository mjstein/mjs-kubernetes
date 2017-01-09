class kubernetes::master($master_name = undef, $minion_name = undef,$alternate_flannel_interface_bind = false) {
  validate_string($master_name)
  validate_array($minion_name)
  class{'kubernetes':
    master_name => $master_name,
    minion_name => $minion_name,
  }->
  file{'/etc/kubernetes/apiserver':
    content => template('kubernetes/apiserver.erb'),
    notify  => Service['kube-apiserver']
  }->
  file{'/etc/kubernetes/controller-manager':
    content => template('kubernetes/controller.erb'),
    notify  => Service['kube-controller-manager']
  }->

  file{'/etc/etcd/etcd.conf':
    ensure  => present,
    source  => 'puppet:///modules/kubernetes/etcd_config',
    require => Package['etcd'],
    notify  => Service['etcd'],
  }->

  service{['etcd', 'kube-apiserver', 'kube-controller-manager', 'kube-scheduler']:
    ensure => running,
    enable => true,
    before => Service['flanneld']
  }->

  file{'/tmp/flannel-config.json':
    ensure => present,
    source => 'puppet:///modules/kubernetes/flannel-config',
  }->

  exec{'populate etcd server':
    path    => ['/bin'],
    command => "curl -L http://${::kubernetes::master_name}:4001/v2/keys/flannel/network/config -XPUT --data-urlencode value@/tmp/flannel-config.json",
    unless  => 'curl -L http://localhost:4001/v2/keys/flannel/network/config;if [ $? -eq 0 ]; then return 1; else return 0;fi', 
    require => File['/tmp/flannel-config.json']
  }~>
  service{'flanneld':
    ensure => running,
    enable => true,
  }~>
  service{'docker':
    ensure => running,
    enable => true,
  }
}
