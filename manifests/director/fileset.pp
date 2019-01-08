# This class handles a Director's fileset.conf entry.  Filesets are intended to
# be included on the Director catalog.  Resources of this type may also be
# exported to be realized by the director.
#
# @param files
# @param conf_dir The bacula configuration director.  Should not need adjusting.
# @param excludes A list of paths to exclude from the filest
# @param options A hash of options to include in the fileset
# @param director_name The name of the director intended to receive this fileset.
#
# @example
#   bacula::director::fileset { 'Home':
#     files => ['/home'],
#   }
#
define bacula::director::fileset (
  Array[String]                                $files,
  String                                       $conf_dir      = $bacula::conf_dir,
  String                                       $director_name = $bacula::director_name,
  Array[String]                                $excludes      = [],
  Bacula::Yesno                                $ignore_fileset_changes = false,
  Bacula::Yesno                                $enable_vss    = false,
  Hash[String, Variant[String, Array[String], Bacula::Yesno]] $options       = {
    'signature'   => 'SHA1',
    'compression' => 'GZIP9',
  },
) {
  $epp_fileset_variables = {
    name     => $name,
    options  => $options,
    files    => $files,
    excludes => $excludes,
    ignore_fileset_changes => $ignore_fileset_changes,
    enable_vss =>  $enable_vss,
  }

  concat::fragment { "bacula-fileset-${name}":
    target  => "${conf_dir}/conf.d/fileset.conf",
    content => epp('bacula/fileset.conf.epp', $epp_fileset_variables),
    tag     => "bacula-${director_name}",
  }
}
