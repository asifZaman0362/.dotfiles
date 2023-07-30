{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  home.username = "asifzaman";
  home.homeDirectory = "/Users/asifzaman";

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "UbuntuMono" ]; })
    nodejs_20
    ripgrep
    fd
    exa
    bat
    zsh-powerlevel10k
    ffmpeg
    imagemagick
    trash-cli
    rustup
    nil
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  programs.home-manager.enable = true;

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

  programs.kitty = {
    enable = true;
    font.size = 18;
    font.name = "Hack";
    shellIntegration = {
      enableZshIntegration = true;
    };
    theme = "Rosé Pine";
    settings = {
      shell = "tmux";
      editor = "nvim";
    };
    #extraConfig = "background_opacity 1";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = (builtins.readFile ./init.vim);
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      mason-nvim
      toggleterm-nvim
      nvim-treesitter
      neogit
      nvim-lspconfig
      emmet-vim
      rust-tools-nvim
      nvim-treesitter-context
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.c
      nvim-treesitter-parsers.cpp
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.html
      nvim-treesitter-parsers.markdown
      nvim-treesitter-parsers.markdown_inline
      nvim-treesitter-parsers.typescript
      nvim-treesitter-parsers.javascript
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-vsnip
      cmp-zsh
      cmp-rg
      cmp-git
      cmp-buffer
      cmp-nvim-lua
      cmp-nvim-lsp-signature-help
      cmp-nvim-lsp-document-symbol
      rose-pine
    ];
  };
}
