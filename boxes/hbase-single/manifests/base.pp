class base {
  include apt
  include stdlib

  group { 'puppet': ensure => 'present' }

  package {
    'curl':
      ensure => present;
    'openjdk-6-jdk':
      ensure => present;
    'hadoop-hbase':
      ensure => 'present',
      require => [
        Package['openjdk-6-jdk'],
        File_line['JAVA_HOME'],
        Apt::Source['cloudera']];
    'hadoop-hbase-master':
      ensure => 'present',
      require => Package['hadoop-hbase'];
    'hadoop-hbase-thrift':
      ensure => 'present',
      require => Package['hadoop-hbase'];
  }

  apt::source { 
    'cloudera':
      location   => 'http://archive.cloudera.com/debian',
      release    => 'lucid-cdh3',
      repos      => 'contrib',
      key        => '327574EE02A818DD',
      key_source => 'http://archive.cloudera.com/debian/archive.key';
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

  file_line { 
    'JAVA_HOME':
    path => '/etc/environment',
    line => "JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk" 
  }

  
}

include base
