{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  unstable = inputs.nixpkgs-unstable;
  #swaybarStatus = pkgs.writeShellScriptBin "status.sh" (builtins.readFile ../config/sway/status.sh); # this seems weird and redundant
in
{
  imports = [ outputs.homeManagerModules.gnome-dash-to-dock ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  home.username = "bened";
  home.homeDirectory = "/home/bened";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    #development
    jetbrains.rider
    pgadmin4-desktopmode
    direnv
    dotnet-sdk_8
    ghc
    elixir
    inotify-tools
    gnumake
    gcc

    #communication
    signal-desktop
    discord
    element-desktop

    #entertainment
    spotify
    calibre

    #utilities
    keepassxc
    obsidian
    mpv
    yt-dlp
    rclone
    xclip
    unzip
    file
    wineWowPackages.stable
    winetricks
    remmina
    chromium
    kdePackages.kleopatra
    fzf
    thunderbird
    gnupg
    zathura
    khal
    pass
    vdirsyncer
    alacritty
    gimp

    #games
    steam
    lutris
    prismlauncher

    #gnome
    gnome.gnome-tweaks

    #sway
    swaylock
    swayidle
    wmenu
    st
  ];

  programs.gnome-dash-to-dock = {
    enable = true;

    appearance = {
      extendHeight = true;
      dashMaxIconSize = 32;
      dockPosition = "LEFT";
      shrinkDash = true;
      applyCustomTheme = false;
    };

    behavior = {
      hotKeys = false;
      disableOverviewOnStartup = true;
      dockFixed = true;
    };

    show = {
      mounts = false;
      mountsNetwork = false;
      trash = false;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      hmconfig = "vim ${config.xdg.configHome}/home-manager/home.nix";
      hmupdate = "home-manager switch";
      nixconfig = "sudo vim /etc/nixos/configuration.nix";
      nixupdate = "sudo nixos-rebuild switch";
      deinit = "echo 'use flake' > .envrc; direnv allow";
    };

    initExtra = ''
      eval "$(direnv hook zsh)"
    '';

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "half-life";
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
  };

  programs.vim =
    let
      omnisharp-vim = pkgs.vimUtils.buildVimPlugin {
        name = "omnisharp-vim";
        src = pkgs.fetchFromGitHub {
          owner = "OmniSharp";
          repo = "omnisharp-vim";
          rev = "f9c5d3e3375e8b5688a4506e813cb21bdc7329b1";
          hash = "sha256-z3Dgrm9pNWkvfShPmB9O8TqpY592sk1W722zduOSing=";
        };
      };
    in
    {
      enable = true;
      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-lastplace
        YouCompleteMe
        ReplaceWithRegister
        vim-peekaboo
        nerdtree
        vim-polyglot
        vim-elixir
        ctrlp-vim
        #omnisharp-vim # TODO fix this plugin?
      ];

      extraConfig = ''
        set nocompatible
        set backspace=indent,eol,start
        syntax on
        set number relativenumber
        set scrolloff=10
        set wrap
        set hlsearch
        set incsearch
        set showcmd
        set showmode
        set showmatch
        set background=dark

        let mapleader=","

        nnoremap <leader>, ``
        map <space> /

        nnoremap <leader>n :NERDTreeFocus<CR>
        nnoremap <C-n> :NERDTree<CR>
        nnoremap <C-t> :NERDTreeToggle<CR>
        nnoremap <C-f> :NERDTreeFind<CR>

        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
        autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
      '';
    };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      elixir-lsp.vscode-elixir-ls
      bradlc.vscode-tailwindcss
      stefanjarina.vscode-eex-snippets
    ];
  };

  programs.git = {
    enable = true;
    userEmail = "benedikt.zundel@live.com";
    userName = "Benedikt Zundel";

    extraConfig = {
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      pull.rebase = false;
      core.editor = "vim";
    };
  };

  programs.gnome-shell = {
    enable = true;

    theme = {
      name = "Yaru-purple-dark";
      package = pkgs.yaru-theme;
    };

    extensions = [
      { package = pkgs.gnomeExtensions.dash-to-dock; }
      { package = pkgs.gnomeExtensions.vitals; }
      { package = pkgs.unstable.gnomeExtensions.systemd-manager; }
    ];
  };

  programs.gnome-terminal = {
    enable = true;

    profile."d389d7f9-374e-49ad-9230-09407436358f" = {
      default = true;
      visibleName = "Default";
      allowBold = true;
      audibleBell = false;
      boldIsBright = true;
      font = "Ubuntu Mono Bold 12";
    };
  };

  home.file = {
    ".config/khal/config" = {
      source = ../config/khal/config;
    };

    ".vdirsyncer/config" = {
      source = ../config/vdirsyncer/config;
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  gtk = {
    enable = true;

    cursorTheme = {
      package = pkgs.yaru-theme;
      name = "Yaru";
    };

    font = {
      package = pkgs.ubuntu_font_family;
      name = "Ubuntu";
      size = 11;
    };

    iconTheme = {
      package = pkgs.yaru-theme;
      name = "Yaru-purple-dark";
    };

    theme = {
      package = pkgs.yaru-theme;
      name = "Yaru-purple-dark";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod1";
      terminal = "st";

      left = "h";
      down = "j";
      up = "k";
      right = "l";

      defaultWorkspace = "workspace number 1";

      keybindings = with config.wayland.windowManager.sway.config;
      let
        mod = modifier;
      in {
        "${mod}+Shift+Return" = "exec ${terminal}";
        "${mod}+p" = "exec ${menu}";

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+q" = "kill";
        "${mod}+Shift+e" = "exec swaymsg exit";

        "${mod}+f" = "fullscreen";
        "${mod}+e" = "layout toggle split";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";

        "${mod}+${left}" = "focus left";
        "${mod}+${down}" = "focus down";
        "${mod}+${up}" = "focus up";
        "${mod}+${right}" = "focus right";

        "${mod}+Shift+${left}" = "move left";
        "${mod}+Shift+${down}" = "move down";
        "${mod}+Shift+${up}" = "move up";
        "${mod}+Shift+${right}" = "move right";

        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        "${mod}+z" = "focus output left";
        "${mod}+x" = "focus output right";

        "${mod}+Shift+z" = "move output left";
        "${mod}+Shift+x" = "move output right";

        "${mod}+Tab" = "workspace back_and_forth";

        "${mod}+Shift+s" = "exec swaylock -c 000000";

        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && pkill -RTMIN+1 i3blocks";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && pkill -RTMIN+1 i3blocks";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && pkill -RTMIN+1 i3blocks";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && pkill -RTMIN+1 i3blocks";

        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+n" = "split none";

        "${mod}+Shift+space" = "floating toggle";

        "${mod}+r" = ''mode "resize"'';
      };

      modes = {
        resize = with config.wayland.windowManager.sway.config; {
          "${left}" = "resize shrink width 10px";
          "${down}" = "resize grow height 10px";
          "${up}" = "resize shrink height 10px";
          "${right}" = "resize grow width 10px";

          "Return" = ''mode "default"'';
          "Escape" = ''mode "default"'';
        };
      };

      output = {
        "*" = {
          background = "#000000 solid_color";
        };

        "eDP-1" = {
          pos = "3840 1080";
        };

        "DP-3" = {
          pos = "0 0";
        };
      };

      input = {
        "type:touchpad" = {
          click_method = "button_areas";
          natural_scroll = "disabled";
          tap = "enabled";
          dwt = "enabled";
        };
      };


      startup = [
        {
          command = ''xsetroot -solid "#000000"'';
        }
      ];
    };
  };

  systemd.user.services.rclone-onedrive = {
    Unit = {
      Description = "Mount OneDrive to home using rclone";
    };

    Service =
      let
        onedriveDir = "/home/bened/cloud";
      in
      {
        Type = "simple";
        ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode writes onedrive:/Personal/KeePassDatabase ${onedriveDir}";
        ExecStop = "/run/wrappers/bin/fusermount -u ${onedriveDir}";
        Restart = "on-failure";
        RestartSec = "10";
      };
  };

  programs.home-manager.enable = true;
}
