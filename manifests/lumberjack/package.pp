class logstash::lumberjack::package (
  $package_name    = 'lumberjack',
  $package_version = '0.0.30-1',
) {
  package { $package_name:
    ensure => $package_version
  }
}
