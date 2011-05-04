# Class: collectd::client
#
# This class configures the collectd client
#
# Parameters:
#
# Actions:
#
# Requires:
#   - collectd::params
#
# Sample Usage:
#
# class { "collectd::client": server => "collectd.example.com"; }
#
class collectd::client (
  $server
  ) {

  include collectd::params
  include collectd

  $collectd_server = $server

  file { 'collectd-client':
    path => $collectd::params::collectd_configuration,
    content => template('collectd/collectd-client.conf.erb'),
    ensure => present,
    require => Package['collectd'],
  }

  @@firewall { "0160-INPUT allow 25826 udp $ipaddress":
    proto  => 'udp',
    dport  => '25826',
    source => "$ipaddress",
    jump   => 'ACCEPT',
  }

}
