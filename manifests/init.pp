# Configure etckeeper with git
class etckeeper {

  $etckeeper_pkgs = ['etckeeper', 'git']
  ensure_packages($etckeeper_pkgs, {tag => 'nectar'})

  file { '/etc/etckeeper/etckeeper.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/etckeeper/etckeeper.conf',
    require => Package['etckeeper'],
  }

  exec { 'etckeeper-init':
    path      => '/usr/bin:/usr/sbin:/bin:/sbin',
    command   => 'etckeeper init -d /etc',
    subscribe => File['/etc/etckeeper/etckeeper.conf'],
    unless    => 'test -d /etc/.git',
  }

  file { '/etc/.git/config':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('etckeeper/gitconfig.erb'),
    require => Exec[etckeeper-init],
  }
}
