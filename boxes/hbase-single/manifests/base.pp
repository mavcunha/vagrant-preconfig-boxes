class base {
  include apt
  include apt::update
  include stdlib

  group { 'puppet': ensure => 'present' }

  Exec["apt_update"] -> Package <||>

  package {
    'curl':
      ensure => present;
    'openjdk-6-jdk':
      ensure => present;
    'hadoop-hbase':
      ensure  => 'present',
      require => [
        Package['openjdk-6-jdk'], 
        File['java_home'],
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

  file { 
  '/etc/profile.d/set_java_home.sh':
    ensure  => present,
    alias   => 'java_home',
    content => 'export JAVA_HOME="/usr/lib/jvm/java-1.6.0-openjdk"';
  }
}

include base
