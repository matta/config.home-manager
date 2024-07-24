{ config, pkgs, ... }:

let
  # note: you can store this in an external file like the NixOS manual
  # example as well:
  # https://nixos.org/manual/nixos/stable/index.html#module-services-emacs-adding-packages
  # my_emacs_package = pkgs.emacsWithPackagesFromUsePackage {
  #   config = ../emacs/init.el;
  #   package = pkgs.emacs-gtk;
  #   # package = pkgs.emacsPgtk;
  # };
in
{
  # Enable flakes (see https://wiki.nixos.org/wiki/Flakes)
  #
  # Hmm, this didn't seem to work. But I did have experimental features
  # turned on in my ~/.config/nix/nix.conf so I'll leave this alone for now.
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "matt";
  home.homeDirectory = "/home/matt";

  # See https://discourse.nixos.org/t/home-manager-not-upgrading/36444/3
  # Looks like a regular “we break doc rendering all the time” issue to me.
  # Disable HM man pages, and perhaps HTML docs as well.
  # Variations of this error happen all the time :-(
  manual.html.enable = false;
  manual.manpages.enable = false;

  # See https://github.com/nix-community/home-manager/issues/1439#issuecomment-714830958
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;

  # See also https://github.com/nix-community/home-manager/issues/1439#issuecomment-1440763587

  programs.direnv.enable = true;
  # TODO: this causes home manager to write out .zsh* config files
  # programs.zsh.enable = true;

  #  nixpkgs.overlays = [
  #    (import (builtins.fetchTarball {
  #      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #    }))
  #  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # core utilities
    pkgs.cmake
    # pkgs.coreutils
    # pkgs.curl
    pkgs.fd
    pkgs.fzf
    # pkgs.gcc
    pkgs.gnumake
    pkgs.jq
    pkgs.ripgrep
    pkgs.dig
    # pkgs.zsh

    pkgs.neovide
    pkgs.markdown-oxide
    # pkgs.vim

    # Can't use Nix's pkgs.gitFull because it bundles a ssh that doesn't
    # support gssapikexalgorithms:
    # https://github.com/NixOS/nixpkgs/issues/58132 and
    # https://github.com/NixOS/nixpkgs/issues/160527.
    #
    # Note: this is the kind of paper cut that turns people away from Nix.
    #
    # pkgs.gitFull # full for send-email

    # Hmm, can't install pkgs.clang and pkgs.gcc at the same time due to this error:
    #
    # error: collision between `/nix/store/n95cd4q1dqzdvsiy1hmrkx9shwi3n4sh-gcc-wrapper-11.3.0/bin/c++' and `/nix/store/jysh153c3mb4qc6kwq49yl2fgkvq9vr9-clang-wrapper-11.1.0/bin/c++'
    # error: builder for '/nix/store/f4a5pfs9yhr1p7il3343fc7pk6j0mri0-home-manager-path.drv' failed with exit code 25;
    #        last 1 log lines:
    #        > error: collision between `/nix/store/n95cd4q1dqzdvsiy1hmrkx9shwi3n4sh-gcc-wrapper-11.3.0/bin/c++' and `/nix/store/jysh153c3mb4qc6kwq49yl2fgkvq9vr9-clang-wrapper-11.1.0/bin/c++'
    #
    # pkgs.clang

    pkgs.curl # download stuff
    pkgs.entr # continuously run stuff
    pkgs.fortune # why not?
    pkgs.htop #process monitor
    pkgs.parallel # exec things in parallel
    pkgs.tmux # terminal multiplexer
    pkgs.tree # print a directory tree
    pkgs.wget # download stuff

    # git autofixup: https://torbiak.com/post/autofixup/
    pkgs.git-autofixup # git autofixup

    # programming-shell
    pkgs.shellcheck # shell checker
    pkgs.shfmt # shell code format
    # pkgs.nodePackages.bash-language-server # bash language-server

    # programming-nix
    pkgs.nixfmt-classic # nix formatter
    pkgs.nixpkgs-fmt # another nix formatter, for nixpkgs? wah???
    pkgs.statix # linter for nix

    # experimental
    pkgs.helix
    pkgs.fastfetch
    # pkgs.zed-editor

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/matt/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # programs.emacs = {
    # enable = true;
    # package = pkgs.emacs29-pgtk;
  # };

  programs.lazygit.enable = true;
  programs.gitui.enable = true;
  programs.foot = {
    enable = true;
    settings = {
      main = { };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  #   package = my_emacs_package;
  #   extraPackages = epkgs: [
  #     epkgs.nix-mode
  #     epkgs.magit
  #   ];
  # };

  # TODO: enable syncthing?
  # services.syncthing.enable = true;

  # Put my git-auto-all into a systemd timer managed by home manager:
  #
  # https://mynixos.com/home-manager/option/systemd.user.timers
  #
  # https://github.com/search?q=systemd.user.services+extension%3Anix&type=Code&ref=advsearch&l=&l=
  # https://github.com/search?q=systemd.user.timers+extension%3Anix&type=Code
  # https://github.com/jb55/citadel/blob/50d53c3d05d363623da5671b2fdbd983ce77dd5b/nix-config/machines/monad/default.nix#L177-L185
  #
  # This looks particularly interesting:
  #
  # https://github.com/meain/dotfiles/blob/a2915acc2ca0c271353da16555036ad054fb49fb/nix/.config/nixpkgs/home.nix#L365-L366
  # https://github.com/meain/dotfiles/blob/a2915acc2ca0c271353da16555036ad054fb49fb/nix/.config/nixpkgs/home.nix#L6
  # https://github.com/meain/dotfiles/blob/a2915acc2ca0c271353da16555036ad054fb49fb/nix/.config/nixpkgs/utils.nix
  # https://github.com/meain/dotfiles/commit/cc916a786b0d1c419bf032b26f54ee05cf1c4c92
  systemd.user.services.git-auto-all = {
    Install.WantedBy = [ "default.target" ];
    Service.ExecStart = "%h/env/scripts/git-auto-all";
    Service.Type = "oneshot";
    Unit.RefuseManualStop = "yes";
    Unit.Description = "Automatically synchronize my git repositories";
  };
  systemd.user.timers.git-auto-all = {
    Install.WantedBy = [ "timers.target" ];
    Timer.OnUnitActiveSec = "15m";
    Timer.OnStartupSec = "1m";
    Timer.Persistent = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
