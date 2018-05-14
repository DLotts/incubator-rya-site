#/etc/puppet/modules/mysql_asf/manifests/backup.pp

class mysql_asf::backup (
  $script_path = '/root',
  $script_name = 'dbsave_mysql.sh',
  $hour        = 03,
  $minute      = 45,
  $dumproot    = '/x1/db_dump/mysql',
  $age         = '5d',
) {

  require mysql::server

  file {
    'dbsave.sh':
      path    => "${script_path}/${script_name}",
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      content => template('mysql_asf/dbsave_mysql.sh.erb'),
  }

  tidy { 'mysql-dumps':
    path    => $dumproot,
    age     => $age,
    recurse => true,
    matches => ['*.sql.gz'],
  }

  cron { 'mysql-dump-rsync-to-abi':
    hour    => $hour,
    minute  => $minute,
    command => "${script_path}/${script_name}",
  }
}
