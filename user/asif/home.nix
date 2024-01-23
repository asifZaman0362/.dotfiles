{ config, pkgs, lib, ... }:

let
    homeDir = "/home/asif"; username = "asif"; in
{
    # allow using unfree packages
    nixpkgs.config.allowUnfree = true;

    # Let Home Manager install and manage itself:
    programs.home-manager.enable = true;

    # Home Manager needs a bit of information about you and the paths it should manage:
    home.username = "${username}";
    home.homeDirectory = "${homeDir}";

    # This value determines the Home Manager release that your configuration is compatible with.
    # This helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.
    #
    # You can update Home Manager without changing this value.
    # See the Home Manager release notes for a list of state version changes in each release.
    home.stateVersion = "23.11";

    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
      }))
    ];

    # programs to install for the current user
    home.packages = with pkgs; [
        obs-studio
        btop
        zsh-powerlevel10k 
        zsh-autosuggestions
        zsh-syntax-highlighting
        zsh-vi-mode
        discord betterdiscordctl
        ssh-agents
        numix-cursor-theme
        flat-remix-gtk
        flat-remix-icon-theme
        genymotion
        cinnamon.nemo-with-extensions
        qt5ct
        sqlite
        typescript
        barrier
        handbrake
        spotify
        unzip
        blender
        gdb
        steam
    ];

    home.sessionPath = [ "${homeDir}/.scripts" ];

    programs.tmux = {
        enable = true;
        keyMode = "vi";
        mouse = true;
        terminal = "xterm-256color";
        extraConfig = (builtins.readFile ./.tmux.conf);
    };

    programs.gh.enable = true;

    programs.git = {
        enable = true;
        userName = "Asif Zaman";
        userEmail = "zero362001@gmail.com";
    };

    gtk.cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    gtk.theme = {
      name = "Flat-Remix-GTK-Green-Dark-Solid";
      package = pkgs.flat-remix-gtk;
    };

    gtk.iconTheme = {
      name = "Flat-Remix-Yellow-Dark";
      package = pkgs.flat-remix-icon-theme;
    };

    programs.zsh = {
        enable = true;
        shellAliases = {
            slp = "systemctl suspend && slock";
            e = "nvim";
            rm = "trash";
            ls = "exa -la --icons";
            less = "bat";
            python = "python3";
        };
        initExtra = ''
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
            source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
            source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
            source ~/ssh-agent.zsh
        '';
    };

    home.file.".scripts".source = ./scripts;
    home.file.".Xresources".source = ./.Xresources;
    home.file."ssh-agent.zsh".source = ./ssh-agent.zsh;
    home.file.".dwm".source = ./.dwm;

    xdg.configFile."picom.conf".source = ./picom.conf;
    xdg.configFile."hypr".source = ./hypr;
    xdg.configFile."waybar".source = ./waybar;
    xdg.configFile."i3".source = ./i3;
    xdg.configFile."polybar".source = ./polybar;

    programs.kitty = {
        enable = true;
        font.size = 16;
        font.name = "Iosevka Nerd Font";
        shellIntegration = {
            enableZshIntegration = true;
        };
        theme = "Arthur";
        settings = {
            shell = "tmux";
            editor = "nvim";
        };
    };

    services.dunst.enable = false;
    services.kdeconnect.enable = true;
    services.kdeconnect.indicator = true;

    services.network-manager-applet.enable = true;

    services.gnome-keyring = {
        enable = true;
    };

    services.sxhkd = {
        enable = true;
        keybindings = {
            "super + Return" = "kitty";
        };
    };

    #xsession = {
    #    enable = true;
    #    profileExtra = ''
    #        home-server
    #    '';
    #};

    programs.neovim = {
        enable = true;
        package = pkgs.neovim-nightly;
        defaultEditor = true;
        extraConfig = (builtins.readFile ./init.vim);
        extraPackages = with pkgs; [
          lua-language-server
          nodePackages.pyright
          nodePackages.typescript
          nodePackages.typescript-language-server
          shfmt
          sumneko-lua-language-server
          tree-sitter
          nodePackages.prettier_d_slim
          zls
        ];
        plugins = with pkgs.vimPlugins; [
          telescope-nvim nvim-lspconfig emmet-vim mason-nvim
          nvim-cmp cmp-nvim-lsp cmp-path cmp-vsnip cmp-buffer 
          cmp-nvim-lua cmp-nvim-lsp-signature-help cmp-nvim-lsp-document-symbol vim-vsnip
          nvim-treesitter-context lualine-nvim nvim-treesitter nvim-treesitter-parsers.zig
          nvim-treesitter-parsers.javascript nvim-treesitter-parsers.rust nvim-treesitter-parsers.html
          nvim-treesitter-parsers.tsx nvim-treesitter-parsers.cpp nvim-treesitter-parsers.c 
          nvim-treesitter-parsers.rust nvim-treesitter-parsers.python
        ];
  };

  programs.librewolf = {
    enable = true;
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
      "extensions.update.autoUpdateDefault" = true;
      "extensions.update.enabled" = true;
      "identity.fxaccounts.enabled" = true;
      "middlemouse.paste" = false;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "general.useragent.compatMode.firefox" = true;
    };
  };

}
