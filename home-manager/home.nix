{ inputs, outputs, lib, config, pkgs, ... }:
let
  unstable = inputs.nixpkgs-unstable;
in
{
  imports = [
    outputs.homeManagerModules.gnome-dash-to-dock
  ];

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
    file
    dotnet-sdk_8
    ghc

    #communication
    evolution
    signal-desktop
    discord
    element-desktop
    simplex-chat-desktop

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
    wineWowPackages.stable
    winetricks
    remmina
    chromium
    kdePackages.kleopatra
    fzf
    thunderbird
    dmenu
    st

    #games
    steam
    lutris
    prismlauncher
    
    #gnome
    gnome.gnome-tweaks
  ];

  programs.gnome-dash-to-dock = {
    enable = true;
    extendHeight = true;
    dashMaxIconSize = 32;
    disableOverviewOnStartup = true;
    dockFixed = true;
    dockPosition = "LEFT";
    hotKeys = false;
    showMounts = false;
    showMountsNetwork = false;
    showTrash = false;
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

    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-dotnettools.csharp
      ms-dotnettools.vscodeintellicode-csharp
      ms-dotnettools.csdevkit
    ];
  };

  programs.git = {
    enable = true;
    userEmail = "benedikt.zundel@live.com";
    userName = "Benedikt Zundel";

    extraConfig = {
      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
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

  #xsession.windowManager.xmonad = {
  #  enable = true;
  #  config = "${builtins.path { path = "${config.home.homeDirectory}/repos/nixos-config/config/xmonad.hs"; }}";
  #  enableContribAndExtras = true;
  #};

  home.file = {
    #".xmonad/xmonad.hs".source = "${config.home.homeDirectory}/repos/nixos-config/config/xmonad.hs";
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
