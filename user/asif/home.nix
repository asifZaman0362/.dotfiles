{ config, pkgs, ... }:

let
  dotfilesRepo = "https://github.com/asifZaman0362/dotfiles.git";
  dotfilesDir = "${builtins.getEnv "HOME"}/.dotfiles";
in
{
  # Let Home Manager install and manage itself:
  programs.home-manager.enable = true;
  
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
  ];

  programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
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

  programs.gh.enable = true;

  programs.git = {
    userName = "Asif Zaman";
    userEmail = "zero362001@gmail.com";
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
