class logstash::lumberjack2 (
  $files,
  $logstash_servers,
  $package_version = 'installed',
  $ssl_cert_path   = undef,
  $ssl_cert_source = undef,
  $ssl_key_path    = undef,
  $ssl_key_source  = undef,
  $ssl_ca_path     = '/etc/lumberjack/lumberjack.crt',
  $ssl_ca_source   = undef,
  $timeout         = 15,
) {
  class { '::logstash::lumberjack::package': 
    package_version => $package_version,
  }

  class { '::logstash::lumberjack::config':
    servers         => $logstash_servers,
    timeout         => $timeout,
    files           => $files,
    ssl_cert_path   => $ssl_cert_path,
    ssl_cert_source => $ssl_cert_source,
    ssl_key_path    => $ssl_key_path,
    ssl_key_source  => $ssl_key_source,
    ssl_ca_path     => $ssl_ca_path,
    ssl_ca_source   => $ssl_ca_source,
  }
  Class['::logstash::lumberjack::package'] -> Class['::logstash::lumberjack::config']
}
