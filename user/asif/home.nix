{ config, pkgs, libs, ... }:

let
  dotfilesRepo = "https://github.com/asifZaman0362/dotfiles.git";
  dotfilesDir = "${builtins.getEnv "HOME"}/.dotfiles";
  homeDir = "/home/asif";
  username = "asif";
in
{
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
  
  home.packages = with pkgs; [
    audacity
    gnome.gnome-boxes
    gimp
    jack2
    nodejs_20
    gh
    ripgrep
    fd
    exa
    bat
    trash-cli
    zsh
    zsh-powerlevel10k
    gnumake
    nix-prefetch-git
    tmux
    ffmpeg
    vlc
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
    #zplug = {
    #    enable = true;
    #    plugins = [
    #        { name = "zsh-users/zsh-autosuggestions"; }
    #        { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
    #        { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
    #        { name = "plugins/ssh-agent"; tags = [ from:oh-my-zsh ]; }
    #        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
    #    ];
    #};
    oh-my-zsh = {
        enable = true;
        plugins = [ "git" "ssh-agent" ];
        theme = "half-life";
    };
    initExtra = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    #initExtra = "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";
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

  #home.file.".dotfiles".source = lib.cleanSource {
  #  name = "dotfiles";
  #  system = builtins.currentSystem;
  #  src = fetchgit {
  #      url = dotfilesRepo;
  #      rev = "main";
  #  };
  #};

  home.file.".scripts".source = ./scripts;
  home.file.".Xresources".source = ./.Xresources;

  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua".source = ./nvim/lua;
  xdg.configFile."alacritty".source = ./alacritty;

  xsession = {
    enable = true;
    initExtra = ''
    nitrogen --restore &
    statuscmd &
    '';
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

  services.picom = {
    enable = true;
    fade = true;
    backend = "glx";
    vSync = true;
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 5;
      };
    };
  };


  #home.file.".dotfilesDir".source = "${config.home.file[".dotfiles"]}/.";
  #home.file.".dotfilesDir".target = dotfilesDir;
  
}
