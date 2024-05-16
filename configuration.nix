{ pkgs, lib, inputs, ... }: {
  imports =
    [
      ./hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.fuse.userAllowOther = true;
  networking.networkmanager.enable = true;
  
  system.stateVersion = "23.11";

    users.users."bloodwolfe" = {
    isNormalUser = true;
    initialPassword = "12345";
    extraGroups = [ "wheel" ];
  };

  #Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
  #keygen
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
    hostKeys = [
      {
        bits = 4096;
        path = "/persist/system/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/persist/system/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      } 
    ];
  };
  sops = {
    #defaultSopsFile = ./secrets.yaml;
    #validateSopsFiles = false;
    #defaultSopsFormat = "yaml";
    age = {
     sshKeyPaths = [ "/persist/system/etc/ssh/ssh_host_ed25519_key" ];
     keyFile = "/persist/system/var/lib/sops-nix/key.txt";
     generateKey = true;
    };
  };
  environment.systemPackages = with pkgs; [
    git 
    sops 
    neovim 
    gnupg 
    age 
    ssh-to-age
  ];
}
