{ config, pkgs, lib, ... }: {
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableScDaemon = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    pinentryPackage = pkgs.pinentry-tty;
    verbose = true;
    #sshKeys = [ ];
    
  };
  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.gnupg";
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [ 
      {
        source = ./B74857A702B0C92B-2024-04-15.asc;
        trust = 5;
      }
    ];
    scdaemonSettings = {
        disable-ccid = true;
    };
  };
}
