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
      plugins = with pkgs.vimPlugins; [
      	lualine-nvim
	lush-nvim
	nvim-treesitter
	nvim-treesitter-context
	gruvbox-nvim
	emmet-vim
	telescope-nvim
	nvim-tree
	nvim-web-devicons
	mason-nvim
	nvim-lspconfig
	null-ls-nvim
	eslint-nvim
	rust-tools-nvim
	nvim-cmp
	cmp-nvim-lua
	cmp-nvim-lsp
	cmp-nvim-lsp-signature-help
	cmp-nvim-ultisnips
	cmp-nvim-lsp-document-symbol

      ]
  };
