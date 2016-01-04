class kubernetes::minion{
  file{'/etc/kubernetes/kubelet':
    content => template('kubernetes/kubelet.erb') 
  }

  service{['kube-proxy','kubelet', 'docker', 'flanneld']:
    ensure => running,
  }
}

