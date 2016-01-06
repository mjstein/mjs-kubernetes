class kubernetes::minion($master_name=undef, $minion_name=undef){
  class{'kubernetes':
    master_name => $master_name,
    minion_name => $minion_name,
  }->
  file{'/etc/kubernetes/kubelet':
    content => template('kubernetes/kubelet.erb')
  }~>
  service{['kube-proxy','kubelet', 'docker', 'flanneld']:
    ensure => running,
  }
}

