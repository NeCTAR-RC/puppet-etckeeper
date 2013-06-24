class etckeeper {

  $etckeeper_pkgs = ['etckeeper', 'git']

  package { $etckeeper_pkgs:
    ensure  => installed,
    notify  => File['/etc/etckeeper/etckeeper.conf']
  }

  file { '/etc/etckeeper/etckeeper.conf':
    mode      => 0644,
    source    => 'puppet:///modules/etckeeper/etckeeper.conf',
    subscribe => Package[$etckeeper_pkgs],
    notify    => Exec['etckeeper-init'],
  }

  exec { etckeeper-init:
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    command     => 'etckeeper init -d /etc',
    subscribe   => File['/etc/etckeeper/etckeeper.conf'],
    unless      => 'test -d /etc/.git',
  }

  file { '/etc/.git/config':
    mode    => 0644,
    content => template('etckeeper/gitconfig.erb'),
    require => Exec[etckeeper-init],
  }
}
