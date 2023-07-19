{ config, pkgs, libs, ... }:

let
    homeDir = "/home/asif";
    username = "asif";
in
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

    # programs to install for the current user
    home.packages = with pkgs; [
        scrot
        go
        audacity
        gimp
        jack2
        nodejs_20
        gh
        ripgrep
        fd
        exa
        bat
        trash-cli
        zsh-powerlevel10k
        nix-prefetch-git
        tmux
        ffmpeg
        vlc
        discord
        betterdiscordctl
        rustup
        imagemagick
    ];

    home.sessionPath = [ "${homeDir}/.scripts" ];

    programs.tmux = {
        enable = true;
        keyMode = "vi";
        mouse = true;
        plugins = with pkgs.tmuxPlugins; [ 
            battery
            sensible
            gruvbox
        ];
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
            enable = true;
            plugins = [
                { name = "zsh-users/zsh-autosuggestions"; }
                { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
                { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
                { name = "plugins/ssh-agent"; tags = [ from:oh-my-zsh ]; }
                { name = "jeffreytse/zsh-vi-mode"; }
                #{ name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
            ];
        };
        initExtra = ''
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '';
    };

    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        withNodeJs = true;
        withPython3 = true;
        defaultEditor = true;
        extraPackages = with pkgs; [
          nodePackages.pyright
          nodePackages.typescript
          nodePackages.typescript-language-server
          shfmt
          sumneko-lua-language-server
          tree-sitter
          nodePackages.prettier_d_slim
        ];
    };

    home.file.".scripts".source = ./scripts;
    home.file.".Xresources".source = ./.Xresources;

    xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
    xdg.configFile."nvim/lua".source = ./nvim/lua;
    xdg.configFile."alacritty".source = ./alacritty;
    xdg.configFile."hypr".source = ./hypr;
    xdg.configFile."waybar".source = ./waybar;

    programs.kitty = {
        enable = true;
        font.size = 20;
        font.name = "FantasqueSansM Nerd Font";
        shellIntegration = {
            enableZshIntegration = true;
        };
        theme = "Gruvbox Dark Hard";
        settings = {
            shell = "tmux";
            editor = "nvim";
        };
        extraConfig = "background_opacity 0.9";
    };

    programs.wofi = {
        enable = true;
        settings = {
            allow_markup = true;
        };
        style = (builtins.readFile ./waybar.css);
    };

    gtk.iconTheme = {
        package = pkgs.gruvbox-dark-icons-gtk;
        name = "Gruvbox-Dark";
    };

    gtk.theme = {
        package = pkgs.gruvbox-dark-gtk;
        name = "gruvbox-dark-gtk";
    };

    services.dunst.enable = true;
    services.kdeconnect.enable = true;
    services.kdeconnect.indicator = true;

    services.network-manager-applet.enable = true;

    #services.picom = {
    #    enable = true;
    #    fade = true;
    #    backend = "glx";
    #    vSync = true;
    #    settings = {
    #        blur = {
    #            method = "dual_kawase";
    #            strength = 5;
    #        };
    #    };
    #};

    services.gnome-keyring = {
        enable = true;
    };

    services.sxhkd = {
        enable = true;
        keybindings = {
            "ctrl + alt + end" = "obs-cli 'Ending'";
            "ctrl + alt + home" = "obs-cli 'Scene'";
            "ctrl + alt + insert" = "obs-cli 'Starting'";
            "ctrl + alt + del" = "obs-cli 'Idle'";
        };
    };

    xsession = {
        enable = true;
        profileExtra = ''
            home-server
        '';
    };

}
