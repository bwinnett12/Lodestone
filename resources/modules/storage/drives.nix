# resources/modules/storage/drives.nix
# Single source of truth: every known drive in the ecosystem.
# mode = "hotplug" -> automount + udev start/stop rules + short device timeout
# mode = "always"  -> mounted at boot, no automount dance (internal/always-on disks)
{
  # Example    = { uuid =  "#SSID";                                fsType = "btrfs"; mode = "hotplug"; };
  
  ### External Drives
  Tulip      = { uuid = "809C-FB5D";                             fsType = "exfat"; mode = "hotplug"; };
  Lilac      = { uuid = "7237-9737";                             fsType = "exfat"; mode = "hotplug"; };

  ### Internal Drives
  Hydrangea  = { uuid = "65833cdf-0486-46da-9809-3a89d99858a3";  fsType = "btrfs"; mode = "hotplug"; };
  Nettle     = { uuid = "10ba586f-c9b7-48ce-a8e5-7f5adbb34ab9";  fsType = "ext4";  mode = "hotplug";  };
  Orchid     = { uuid = "4074ccad-cc37-4e98-9d6b-9dead0b25e1d";  fsType = "btrfs"; mode = "hotplug";  };
  Snapdragon = { uuid = "82cd7f0f-bec7-4c4c-abea-de71b5f9a18a";  fsType = "btrfs"; mode = "hotplug";  };
  Yarrow     = { uuid = "6EFF-B51B";                             fsType = "exfat"; mode = "hotplug"; };
}