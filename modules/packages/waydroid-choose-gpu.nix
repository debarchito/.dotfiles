{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.waydroid-choose-gpu =
        pkgs.writers.writeFishBin "waydroid-choose-gpu" { }
          # fish
          ''
            set CP        ${lib.getExe' pkgs.coreutils "cp"}
            set DATE      ${lib.getExe' pkgs.coreutils "date"}
            set RG        ${lib.getExe pkgs.ripgrep}
            set LSPCI     ${lib.getExe pkgs.pciutils}
            set SD        ${lib.getExe pkgs.sd}
            set WAYDROID  ${lib.getExe pkgs.waydroid-nftables}

            set lspci_out ("$LSPCI" -nn | "$RG" '\[03')

            if test -z "$lspci_out"
              echo "No GPUs found."
              exit 1
            end

            echo -e "Please enter the GPU number you want to pass to WayDroid:\n"

            set -l i 0
            for line in $lspci_out
              set i (math $i + 1)
              echo "  $i. $line"
            end

            set -l gpuchoice ""
            while test -z "$gpuchoice"
              read -l -P ">> Number of GPU to pass to WayDroid (1-$i): " ans
              if string match -qr '^[0-9]+$' "$ans"; and test "$ans" -ge 1; and test "$ans" -le "$i"
                set -l selected_line $lspci_out[$ans]
                set gpuchoice (string split " " $selected_line)[1]
              end
            end

            echo -e "\nConfirming DRI nodes for GPU: $gpuchoice\n"

            set -l dri_paths (ls -l /dev/dri/by-path/ | "$RG" -i "$gpuchoice")
            echo "$dri_paths"

            set -l card (echo "$dri_paths" | "$RG" -o "card[0-9]" | head -n1)
            set -l rendernode (echo "$dri_paths" | "$RG" -o "renderD[0-9]{3}" | head -n1)

            if test -z "$card"; or test -z "$rendernode"
              echo "Could not find DRI nodes for $gpuchoice"
              exit 1
            end

            echo "Selected: /dev/dri/$card & /dev/dri/$rendernode"

            set -l timestamp ("$DATE" +%Y-%m-%d-%H:%M)
            set -l config_nodes "/var/lib/waydroid/lxc/waydroid/config_nodes"
            set -l waydroid_cfg "/var/lib/waydroid/waydroid.cfg"

            if test -f "$config_nodes"
              run0 "$CP" "$config_nodes" "$config_nodes"_"$timestamp".bak
            end

            if test -f "$waydroid_cfg"
              run0 "$CP" "$waydroid_cfg" "$waydroid_cfg"_"$timestamp".bak
              run0 "$SD" '(?m)^drm_device\s*=.*$\n?' "" "$waydroid_cfg"
              run0 "$SD" '(\[waydroid\])' '$1\ndrm_device = /dev/dri/'"$rendernode" "$waydroid_cfg"
            end

            run0 "$WAYDROID" upgrade --offline
          '';
    };
}
