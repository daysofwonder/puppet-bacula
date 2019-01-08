# This define creates a storage autochanger declaration.  This informs the
# storage daemon which storage devices are autochangers and how to autochange tapes.
#
# @param device_name     - Bacula director configuration for Device option 'Name'
#
define bacula::storage::autochanger (
  String           $device_name,
  String           $changer_device,
  String           $autochanger_name = $name,
  String           $conf_dir         = $bacula::conf_dir,
  Optional[String] $changer_command  = undef,
) {
  $epp_autochanger_variables = {
    device_name      => $device_name,
    autochanger_name => $autochanger_name,
    changer_device   => $changer_device,
    changer_command  => $changer_command,
  }

  concat::fragment { "bacula-storage-autochanger-${name}":
    target  => "${conf_dir}/bacula-sd.conf",
    content => epp('bacula/bacula-sd-autochanger.epp', $epp_autochanger_variables),
  }
}
