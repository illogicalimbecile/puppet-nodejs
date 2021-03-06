# = Class: nodejs
#
# == Parameters:
#
# [*version*]
#   The NodeJS version ('vX.Y.Z', 'latest' or 'stable').
#
# [*target_dir*]
#   Where to install the executables.
#
# [*with_npm*]
#   Whether to install NPM.
#
# [*make_install*]
#   If false, will install from nodejs.org binary distributions.
#
# == Example:
#
#  include nodejs
#
#  class { 'nodejs':
#    version  => 'v0.10.17'
#  }
#
class nodejs (
  $version      = 'stable',
  $target_dir   = '/usr/local/bin',
  $with_npm     = true,
  $make_install = true,
) {

  nodejs::install { "nodejs-${version}":
    version       => $version,
    target_dir    => $target_dir,
    with_npm      => $with_npm,
    make_install  => $make_install,
  }

  $node_version = $version ? {
    undef     => $::nodejs_stable_version,
    'stable'  => $::nodejs_stable_version,
    'latest'  => $::nodejs_latest_version,
    default   => $version
  }

  $nodejs_version_path = "/usr/local/node/node-${$node_version}"
  $nodejs_default_path = '/usr/local/node/node-default'
  $nodejs_default_node = "${target_dir}/node"
  $nodejs_default_npm  = "${target_dir}/npm"

  file { $nodejs_default_path:
    ensure  => link,
    target  => $nodejs_version_path,
    require => Nodejs::Install["nodejs-${version}"],
  }

  file { $nodejs_default_node:
    ensure  => link,
    target  => "${nodejs_default_path}/bin/node",
    require => File[$nodejs_default_path],
  }

  file { $nodejs_default_npm:
    ensure  => link,
    target  => "${nodejs_default_path}/bin/npm",
    require => File[$nodejs_default_path],
  }

  if $::osfamily != 'FreeBSD' {
    file { '/etc/profile.d/nodejs.sh':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/nodejs.sh.erb"),
      require => File[$nodejs_default_path],
    }
  }

}
