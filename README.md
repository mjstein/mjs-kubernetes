# kubernetes

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with kubernetes](#setup)
    * [What kubernetes affects](#what-kubernetes-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kubernetes](#beginning-with-kubernetes)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module at present install a kubernetes master and minion. it is still heavily in development as at present should only be used on CentOS 7 unless one wishes to add their own repos

## Module Description
Will add a basic minion master setup

## Setup
set the following variables at top scope
```
node 'default'{
  $master_name = 'kube-master'
    $master_ip = '173.16.32.11'
    $minion_name = 'kube-minion1'
    $minion_ip = '173.16.32.12'
    host{$master_name:
      ip => $master_ip
    }
  host{$minion_name:
    ip => $minion_ip
  }
  class {'kubernetes':
    master =>$::master
  }
  contain 'kubernetes'
}
```
I plan to add these variables to hiera asap.

### What kubernetes affects
kubernetes will install a kube master if $master is true, else it will add a minion

### Setup Requirements **OPTIONAL**

none as yet but std lib will be needed soon
### Beginning with kubernetes

I have tested this on CentOS 7 since epel has all of the rpms you will need. no additional packages should be needed. As yet I have not tied down the ordering , this will follow.
## Usage
```
 node 'default'{
   $master_name = 'kube-master'
     $master_ip = '173.16.32.11'
     $minion_name = 'kube-minion1'
     $minion_ip = '173.16.32.12'
     host{$master_name:
       ip => $master_ip
     }
   host{$minion_name:
     ip => $minion_ip
   }
   class {'kubernetes':
     master =>$::master
   }
   contain 'kubernetes'
 }
```

## Reference

kubernetes
kubernetes::master
kubernetes::minion

## Limitations

This should not be considered a production release it is far too young and undeveloped. Nonetheless it can be used as a guide. I would suggest testing this with vagrant.

## Development

I welcome any input since we have very few kubernetes modules

