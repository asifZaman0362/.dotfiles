{ config, pkgs, libs, ... }:

let
    homeDir = "/home/asif";
    username = "asif"; in
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
    home.stateVersion = "23.05";

    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
      }))
    ];

    # programs to install for the current user
    home.packages = with pkgs; [
        zsh-powerlevel10k 
        zsh-autosuggestions
        zsh-syntax-highlighting
        zsh-vi-mode
        discord betterdiscordctl
        ssh-agents
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
        zplug = {
            enable = false;
        #    plugins = [
                #{ name = "zsh-users/zsh-autosuggestions"; }
                #{ name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
                #{ name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
                #{ name = "plugins/ssh-agent"; tags = [ from:oh-my-zsh ]; }
                #{ name = "jeffreytse/zsh-vi-mode"; }
        #    ];
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

    xdg.configFile."picom.conf".source = ./picom.conf;
    #xdg.configFile."hypr".source = ./hypr;
    #xdg.configFile."waybar".source = ./waybar;
    xdg.configFile."i3".source = ./i3;
    xdg.configFile."polybar".source = ./polybar;

    programs.kitty = {
        enable = true;
        font.size = 13;
        font.name = "Martian Mono";
        shellIntegration = {
            enableZshIntegration = true;
        };
        theme = "Rosé Pine";
        settings = {
            shell = "tmux";
            editor = "nvim";
        };
        extraConfig = "background_opacity 0.6";
    };

    #programs.wofi = {
    #    enable = true;
    #    settings = {
    #        allow_markup = true;
    #    };
    #    style = (builtins.readFile ./wofi.css);
    #};

    services.dunst.enable = true;
    services.kdeconnect.enable = true;
    services.kdeconnect.indicator = true;

    services.network-manager-applet.enable = true;

    services.gnome-keyring = {
        enable = true;
    };

    services.sxhkd = {
        enable = true;
        keybindings = {
            "alt + Return" = "kitty";
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
        ];
        plugins = with pkgs.vimPlugins; [
          telescope-nvim mason-nvim toggleterm-nvim nvim-treesitter neogit
          nvim-lspconfig emmet-vim rust-tools-nvim 

          nvim-treesitter-context nvim-treesitter-parsers.nix nvim-treesitter-parsers.c
          nvim-treesitter-parsers.cpp nvim-treesitter-parsers.rust nvim-treesitter-parsers.html
          nvim-treesitter-parsers.markdown nvim-treesitter-parsers.markdown_inline 
          nvim-treesitter-parsers.typescript nvim-treesitter-parsers.javascript

          nvim-cmp cmp-nvim-lsp cmp-path cmp-vsnip cmp-zsh cmp-rg cmp-git cmp-buffer 
          cmp-nvim-lua cmp-nvim-lsp-signature-help cmp-nvim-lsp-document-symbol vim-vsnip

          nvim-tree-lua rose-pine lualine-nvim neogit nvim-dap nvim-dap-ui nvim-dap-virtual-text
          gitsigns-nvim git-blame-nvim lspsaga-nvim
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
