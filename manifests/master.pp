class kubernetes::master($master_name = undef, $minion_name = undef) {
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
    ensure => present,
    source => 'puppet:///modules/kubernetes/etcd_config',
    notify => Service['etcd']
  }->

  service{['etcd', 'kube-apiserver', 'kube-controller-manager', 'kube-scheduler','docker']:
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
    require => File['/tmp/flannel-config.json']
  }~>
  service{'flanneld':
    ensure => running,
    enable => true,
  }
}
