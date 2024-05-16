nix --experimental-features "nix-command flakes" --run github:nix-community/disko -- --mode disko /tmp/bootstrap/disko.nix --arg device '"/dev/nvme0n1"'

nixos-generate-config --no-filesystems --root /mnt

cd /mnt/etc/nixos
rm configuration.nix
cp -r /tmp/bootstrap/* ./

cd
nixos-install --root /mnt --flake /mnt/etc/nixos#default

#reboot
#trust generated keys after reboot
