{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
  rust-esp = unstable.callPackage "/home/vkhougaz/projects/hanging-plotter/esp32/rust-esp-nix" {};
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

  nixpkgs.overlays = [
    (self: super: {
      vscode = unstable.vscode;
    })
  ];
  imports = [
    ./vscode.nix
  ];
  vscode.user = "vkhougaz";
  vscode.homeDir = "/home/vkhougaz";
  vscode.extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      #(unstable.vscode-extensions.matklad.rust-analyzer.override {
      #  rust-analyzer = rust-esp.rust-analyzer;
      #})
  ];

  home.packages = [
    #ffmaster.pkgs.firefox-bin
    #pkgs.firefox
    unstable.pkgs.firefox-bin
    (pkgs.callPackage (pkgs.path + "/pkgs/tools/X11/xdg-utils") {})
    #pkgs.gnupg
    pkgs.lastpass-cli
    pkgs.ncdu # disk usage cli
    # pkgs.git
    # pkgs.vscode
    pkgs.docker
    pkgs.docker-compose
    pkgs.cntr
    # pkgs.xournal
    pkgs.masterpdfeditor
    pkgs.gparted
    pkgs.unetbootin
    pkgs.xorg.xhost
    pkgs.file

    # beastly term file management yee yee
    pkgs.vifm
    pkgs.bashmount
    pkgs.imv

    # pkgs.platformio
    
    # c compilation for nvidia-xconfig
    pkgs.gcc
    pkgs.gnumake
    pkgs.binutils
    pkgs.m4

    pkgs.psmisc
    pkgs.unzip
    pkgs.desktop-file-utils
    pkgs.jq
    pkgs.ripgrep

    # pkgs.go_1_13
    pkgs.nodejs
    pkgs.yarn

    pkgs.grim  # screenshotting
    pkgs.slurp # mouse detection
    pkgs.aha   # term color -> html
    # pkgs.pipewire # screen sharing, no sway support

    pkgs.spotify
    pkgs.signal-desktop
    pkgs.riot-desktop
    #pkgs.standardnotes
    (pkgs.callPackage ./standardnotes.nix {})

    # MuseDev
    pkgs.slack

    pkgs.zsh
    pkgs.oh-my-zsh
    pkgs.spaceship-prompt
    pkgs.direnv
  ];

  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry}/bin/pinentry
    '';
  };
  programs = {
    gpg = {
      enable = true;
    };
    direnv = {
      enable = true;
    };
    git =  {
      enable = true;
      userName = "sdobz";
      userEmail = "vincent@khougaz.com";
    };
    password-store = {
       enable = true;
       package = pkgs.pass.withExtensions
          (exts: with exts; [ pass-import ]);
    };
    vscode.userSettings = {
      "update.channel" = "none";
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      history.extended = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git-extras"
          "git"
          "github"
          "z"
          "pass"
        ];
        custom = "${pkgs.spaceship-prompt}/share/zsh";
        #theme = "frozencow";
        #theme = "agnoster";
        theme = "spaceship";
      };
      loginExtra = ''
        setopt extendedglob
        # source $HOME/.aliases
        export MOZ_ENABLE_WAYLAND=1
        bindkey '^R' history-incremental-pattern-search-backward
        bindkey '^F' history-incremental-pattern-search-forward
        # If running from tty1 start sway
        if [ "$(tty)" = "/dev/tty1" ]; then
          startsway
        fi

        SPACESHIP_PROMPT_ORDER=(
          # time        # Time stamps section (Disabled)
          # user          # Username section
          dir           # Current directory section
          # host          # Hostname section
          git           # Git section (git_branch + git_status)
          # hg            # Mercurial section (hg_branch  + hg_status)
          # package     # Package version (Disabled)
          node          # Node.js section
          # ruby          # Ruby section
          # elixir        # Elixir section
          # xcode       # Xcode section (Disabled)
          # swift         # Swift section
          golang        # Go section
          # php           # PHP section
          rust          # Rust section
          # haskell       # Haskell Stack section
          # julia       # Julia section (Disabled)
          # docker      # Docker section (Disabled)
          # aws           # Amazon Web Services section
          # gcloud        # Google Cloud Platform section
          venv          # virtualenv section
          # conda         # conda virtualenv section
          pyenv         # Pyenv section
          # dotnet        # .NET section
          # ember       # Ember.js section (Disabled)
          # kubectl       # Kubectl context section
          # terraform     # Terraform workspace section
          exec_time     # Execution time
          line_sep      # Line break
          battery       # Battery level and status
          # vi_mode     # Vi-mode indicator (Disabled)
          jobs          # Background jobs indicator
          exit_code     # Exit code section
          char          # Prompt character
        )

        compdef _pass mpass
        zstyle ':completion::complete:mpass::' prefix "$HOME/MuseDev/secrets"
	mpass() {
          PASSWORD_STORE_DIR=$HOME/MuseDev/secrets pass $@
        }

        export EDITOR=vim
      '';
    };
  };
}
