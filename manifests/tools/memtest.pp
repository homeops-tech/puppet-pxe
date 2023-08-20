# Class: pxe::tools::memtest
#
# Adds the memtest image to the menu
#
class pxe::tools::memtest (
  $url = 'https://www.memtest.org/download/v6.20/mt86plus_6.20.binaries.zip',
  $tftp_root = $pxe::tftp_root
) {
  archive { "${tftp_root}/tools/mt86plus_6.20.binaries.zip":
    ensure       => present,
    source       => $url,
    extract      => true,
    extract_path => "${tftp_root}/tools",
    creates      => "${tftp_root}/tools/memtest32.bin",
    require      => Class['Pxe::Tools'];
  }
  file { "${tftp_root}/tools/memtest86+":
    ensure  => link,
    target  => "${tftp_root}/tools/memtest32.bin",
    require => Archive["${tftp_root}/tools/mt86plus_6.20.binaries.zip"];
  }

  # Create the menu entry
  pxe::menu::entry { 'Memtest86+':
    file      => 'menu_tools',
    kernel    => 'tools/memtest86+',
    tftp_root => $tftp_root,
  }
}
