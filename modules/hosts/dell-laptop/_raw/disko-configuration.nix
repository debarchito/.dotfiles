{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            encryptedSwap = {
              size = "16G";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 1;
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [ "tpm2-device=auto" ];
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd:3"
                        "noatime"
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd:3"
                        "noatime"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd:3"
                        "noatime"
                      ];
                    };
                    "@tmp" = {
                      mountpoint = "/tmp";
                      mountOptions = [
                        "compress=zstd:3"
                        "noatime"
                      ];
                    };
                    "@var/lib" = {
                      mountpoint = "/var/lib";
                      mountOptions = [
                        "compress=zstd:3"
                        "noatime"
                      ];
                    };
                    "@var/lib/containers" = {
                      mountpoint = "/var/lib/containers";
                      mountOptions = [
                        "nodatacow"
                        "noatime"
                      ];
                    };
                    "@var/lib/machines" = {
                      mountpoint = "/var/lib/machines";
                      mountOptions = [
                        "nodatacow"
                        "noatime"
                      ];
                    };
                    "@var/lib/libvirt" = {
                      mountpoint = "/var/lib/libvirt";
                      mountOptions = [
                        "nodatacow"
                        "noatime"
                      ];
                    };
                    "@var/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "compress=zstd:3"
                        "noatime"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
