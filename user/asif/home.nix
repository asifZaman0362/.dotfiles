{ config, pkgs, libs, ... }:

let
  dotfilesRepo = "https://github.com/asifZaman0362/dotfiles.git";
  dotfilesDir = "${builtins.getEnv "HOME"}/.dotfiles";
  nixneovim = import (builtins.fetchGit {
    url = "https://github.com/NixNeovim/NixNeovim";
  });
in
{
  # Let Home Manager install and manage itself:
  programs.home-manager.enable = true;


  imports = [
    nixneovim.nixosModules.default
  ];

  nixpkgs.overlays = [
    nixneovim.overlays.default
  ];
  
  # Home Manager needs a bit of information about you and the paths it should manage:
  home.username = "asif";
  home.homeDirectory = "/home/asif";
  
  # This value determines the Home Manager release that your configuration is compatible with.
  # This helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.
  #
  # You can update Home Manager without changing this value.
  # See the Home Manager release notes for a list of state version changes in each release.
  home.stateVersion = "23.05";
  
  home.packages = with pkgs; [
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
  ];

  programs.nixneovim = {

    enable = true;
    
    # to install plugins just activate their modules
    plugins = {
      lsp = {
        enable = true;
        hls.enable = true;
        rust-analyzer.enable = true;
      };
      treesitter = {
        enable = true;
        indent = true;
      };
      lualine = {
        enable = true;
      };
      gruvbox = {
	enable = true;
      };
      telescope.enable = true;
      neogit.enable = true;
      nvim-cmp.enable = true;
    };

    # Not all plugins have own modules
    # You can add missing plugins here
    # `pkgs.vimExtraPlugins` is added by the overlay you added at the beginning
    # For a list of available plugins, look here: [available plugins](https://github.com/jooooscha/nixpkgs-vim-extra-plugins/blob/main/plugins.md)
    #extraPlugins = [ pkgs.vimExtraPlugins.<plugin> ];

    extraConfigVim = ''
    colorscheme gruvbox
    set autoindent
    set smartindent
    set expandtab
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
    set number
    set relativenumber
    '';

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
    zplug = {
        enable = true;
        plugins = [
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
            { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
            { name = "plugins/ssh-agent"; tags = [ from:oh-my-zsh ]; }
            { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        ];
    };
    initExtra = "source ~/.p10k.zsh";
  };

  #home.file.".dotfiles".source = lib.cleanSource {
  #  name = "dotfiles";
  #  system = builtins.currentSystem;
  #  src = fetchgit {
  #      url = dotfilesRepo;
  #      rev = "main";
  #  };
  #};

  #home.file.".dotfilesDir".source = "${config.home.file[".dotfiles"]}/.";
  #home.file.".dotfilesDir".target = dotfilesDir;
  
}
