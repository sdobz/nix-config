{ config, pkgs, lib, ... }:
let
  unstable = import <unstable> {};
  #wl = import (builtins.fetchTarball https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz);
  #unstable = import <unstable> { overlays = [ wl ]; };
  #pkgs = unstable.pkgs;
  wofi_edge = pkgs.callPackage (builtins.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/applications/misc/wofi/default.nix";
    sha256 = "0wfigcrxihcdpkwm7ygkqvah0phw0g1g72k6jah51ng1gm0qvsra";
  }) {};
in
{
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock # lockscreen
      swayidle
      xwayland # for legacy apps
      waybar # status bar
      mako # notification daemon
      unstable.pkgs.alacritty #term
      dmenu # application launcher
      wofi_edge # application launcher?
    ];
  };

  environment = {
    etc = {
      # Put config files in /etc. Note that you also can put these in ~/.config, but then you can't manage them with NixOS anymore!
      "sway/config".source = ./dotfiles/sway/config;
      "sway/focused-cwd".source = ./dotfiles/sway/focused-cwd;
      "xdg/waybar/config".source = ./dotfiles/waybar/config;
      "xdg/waybar/style.css".source = ./dotfiles/waybar/style.css;
    };
  };

  # Here we but a shell script into path, which lets us start sway.service (after importing the environment of the login shell).
  environment.systemPackages = with pkgs; [
    (
      pkgs.writeTextFile {
        name = "startsway";
        destination = "/bin/startsway";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start sway.service
        '';
      }
    )
  ];

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  #services.redshift = {
  #  enable = true;
    # Redshift with wayland support isn't present in nixos-19.09 atm. You have to cherry-pick the commit from https://github.com/NixOS/nixpkgs/pull/68285 to do that.
  #  package = unstable.pkgs.redshift-wlr;
  #};

  programs.waybar.enable = true;
}

