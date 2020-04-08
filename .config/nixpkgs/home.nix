{ config, pkgs, ... }:

let
  ffmaster = import (builtins.fetchTarball {
	  name = "nixos-firefox-master";
	  url = https://github.com/nixos/nixpkgs/archive/bab82e78b287307148ae4c0ca436c4de32d144f0.tar.gz;
	  sha256 = "13d9g2v4jpri4l1q9s1wgl3xsyb46dk657z7h729zm1h3rqn1sil";
	}) {};
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";

  imports = [
    ./vscode.nix
  ];
  vscode.user = "vkhougaz";
  vscode.homeDir = "/home/vkhougaz";
  vscode.extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
  ];

  home.packages = [
    ffmaster.pkgs.firefox-bin
    #pkgs.firefox
    pkgs.lastpass-cli
    # pkgs.git
    # pkgs.vscode
    pkgs.docker
    pkgs.docker-compose
    pkgs.cntr

    pkgs.platformio
    
    # c compilation for nvidia-xconfig
    pkgs.gcc
    pkgs.gnumake
    pkgs.binutils
    pkgs.m4

    pkgs.psmisc
    pkgs.unzip
    pkgs.desktop-file-utils
    pkgs.jq

    # pkgs.go_1_13
    pkgs.nodejs
    pkgs.yarn

    pkgs.grim  # screenshotting
    pkgs.slurp # mouse detection
    pkgs.aha   # term color -> html

    pkgs.spotify
    pkgs.signal-desktop
    #pkgs.standardnotes
    (pkgs.callPackage ./standardnotes.nix {})

    pkgs.zsh
    pkgs.oh-my-zsh
    pkgs.direnv
  ];

  programs = {
    direnv = {
      enable = true;
    };
    git =  {
      enable = true;
      userName = "sdobz";
      userEmail = "vincent@khougaz.com";
    };
    vscode.userSettings = {
      "update.channel" = "none";
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      history.extended = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git-extras"
          "git"
          "github"
          "z"
        ];
        #theme = "frozencow";
        theme = "agnoster";
      };
      loginExtra = ''
        setopt extendedglob
        source $HOME/.aliases
        export MOZ_ENABLE_WAYLAND=1
        bindkey '^R' history-incremental-pattern-search-backward
        bindkey '^F' history-incremental-pattern-search-forward
        # If running from tty1 start sway
        if [ "$(tty)" = "/dev/tty1" ]; then
          startsway
        fi
      '';
    };
  };
}
