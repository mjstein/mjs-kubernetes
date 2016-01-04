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

service{['etcd', 'kube-apiserver', 'kube-controller-manager', 'kube-scheduler', 'flanneld']:
  ensure => running
}
}
