class logstash::lumberjack::config (
  $servers,
  $timeout,
  $files,
  $ssl_cert_path,
  $ssl_cert_source,
  $ssl_key_path,
  $ssl_key_source,
  $ssl_ca_path,
  $ssl_ca_source,
) {
  # TODO(ekay): include json pretty printer if needed

  file { '/etc/init.d/lumberjack':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/logstash/lumberjack.init'
  }

  # TODO(ekay): uncomment this
  #service { 'lumberjack':
  #  ensure    => running,
  #  hasstatus => true,
  #}

  #File['/etc/init.d/lumberjack'] -> Service['lumberjack']

  file { '/etc/lumberjack':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  if $ssl_ca_source {
    file { $ssl_ca_path:
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => $ssl_ca_source,
      require => File['/etc/lumberjack'],
      before  => Service['lumberjack'],
    }
  }

  # TODO(ekay): create ssl key and cert if specified.

  if !is_array($files) or size($files) < 1 {
    fail('Missing or invalid files parameter for Lumberjack. Expected an array of hashes. See https://github.com/jordansissel/lumberjack#configuring.')
  }

  if !is_array($servers) or size($servers) < 1 {
    fail('Missing or invalid servers parameter for Lumberjack. Expected an array of "host:port" server definitions.')
  }

  # assemble config hash per https://github.com/jordansissel/lumberjack#configuring.
  $config = {
    network => {
      servers           => $logstash_servers,
      'ssl certificate' => $ssl_cert_path,
      'ssl key'         => $ssl_key_path,
      'ssl ca'          => $ssl_ca_path,
      timeout           => $timeout,
    },
    files => $files,
  }

  file { '/etc/lumberjack/lumberjack.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => sorted_json($config),
    notify => Service['lumberjack'],
  }

  File['/etc/lumberjack'] -> File['/etc/lumberjack/lumberjack.conf']
}
