{ config, pkgs, ... }:

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
    pkgs.firefox
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

    # pkgs.go_1_13
    pkgs.nodejs
    pkgs.yarn

    pkgs.scrot # screenshotting
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
        bindkey '^R' history-incremental-pattern-search-backward
        bindkey '^F' history-incremental-pattern-search-forward
        # Fixes android-studio in sway
        _JAVA_AWT_WM_NONREPARENTING=1
        # If running from tty1 start sway
        if [ "$(tty)" = "/dev/tty1" ]; then
          startsway
        fi
      '';
    };
  };
}
