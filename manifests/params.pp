# = Class: nodejs::params
#
# This class defines default parameters used by the main module class nodejs.
# Operating Systems differences in names and paths are addressed here.
#
# == Variables:
#
# Refer to nodejs class for the variables defined here.
#
# == Usage:
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
#
class nodejs::params {
  $install_dir = '/usr/local/node'
  $target_dir  = '/usr/local/bin'

  $admin_group = $::osfamily ? {
    'FreeBSD' => 'wheel',
    default   => 'root',
  }
  $curl_package = $::osfamily ? {
    'FreeBSD' => 'ftp/curl',
    default   => 'curl',
  }

  $gplusplus_package = $::osfamily ? {
    'RedHat'  => 'gcc-c++',
    'FreeBSD' => undef,
    default   => 'g++',
  }

  $make_package = $::osfamily ? {
    'FreeBSD' => 'devel/gmake',
    default   => 'make',
  }

  $python_package = $::osfamily ? {
    'FreeBSD' => 'lang/python',
    default   => 'python',
  }
}
