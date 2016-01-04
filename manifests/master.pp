class kubernetes::master {

file{'/etc/kubernetes/apiserver':
  content => template('kubernetes/apiserver.erb'),
  notify  => Service['kube-apiserver']
}
file{'/etc/kubernetes/controller-manager':
  content => template('kubernetes/controller.erb'),
  notify  => Service['kube-controller-manager']
}

file{'/etc/etcd/conf':
  ensure => present,
  source => 'puppet:///modules/kubernetes/etcd_config',
  notify => Service['etcd']
}

service{['etcd', 'kube-apiserver', 'kube-controller-manager', 'kube-scheduler']:
  ensure => running
}

file{'/tmp/flannel-config.json':
  ensure => present,
  source => 'puppet:///modules/kubernetes/flannel-config',
}

exec{'populate etcd server':
  path    => ['/bin'],
  command => 'curl -L http://kube-master:4001/v2/keys/flannel/network/config -XPUT --data-urlencode value@/tmp/flannel-config.json',
  notify  => Service['flanneld'],
  require => File['/tmp/flannel-config.json']
}
service{'flanneld':
  ensure => running,
}
}
