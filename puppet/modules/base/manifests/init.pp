# == Class: base
#

class base {

  $vim = $::operatingsystem ? {
    /RedHat|Fedora|Centos/ => 'vim-enhanced',
    default => 'vim',
  }

  $editors = ['joe', $vim]
  $vcs = ['git']

  case $operatingsystem {
    /Debian|Ubuntu/: {
      exec { "apt-get update":
        command => "/usr/bin/apt-get update",
        before => Exec["apt-get upgrade"],
        timeout => 1800,
      }

      exec { "apt-get upgrade":
        command => "/usr/bin/apt-get upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'",
        require => Exec["apt-get update"],
        timeout => 1800,
      }
    }
  }

  package { $editors:
    ensure => latest
  }

  package { $vcs:
    ensure => latest
  }

  file { '/usr/local/bin/git_clone.sh':
    owner => 'root',
    group => 'root',
    mode => '0755',
    source => 'puppet:///modules/base/git_clone.sh',
    require => Package[$vcs],
  }

}
