class base {
  include apt
  include hbase

  group { 'puppet': ensure => 'present' }

  package {
    'curl':
      ensure => present
  }

  service {
    hadoop-hbase-thrift:
      enable => true,
      ensure => running,
      hasstatus => true,
      require => [Package['hadoop-hbase-thrift'], Service['hadoop-hbase-master']];

    hadoop-hbase-master:
      enable => true,
      ensure => running,
      hasstatus => true,
      require => [Package['hadoop-hbase-master']];
  }
  
}

include base
