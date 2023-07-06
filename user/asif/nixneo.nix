  programs.nixneovim = {

    enable = true;
    
    # to install plugins just activate their modules
    plugins = {
      lsp = {
        enable = true;
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
      rust = {
      	enable = true;
      };
      zig = {
      	enable = true;
      };
      nix = {
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
