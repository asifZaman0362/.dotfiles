{
  description = "My nixos system configuration";

  inputs = {
  	nixos-config.url = "file:///home/asif/.dotfiles/system/configuration.nix";
	nixneovim.url = "github:nixneovim/nixneovim";
  };

  outputs = { self, nixpkgs, nixneovim }: {

    nixosConfigurations = {
	myhost = nixpkgs.lib.nixosSystem {
	    system = "x86_64-linux";
	    modules = [
	        ({ config, pkgs, ... }: {
		    imports = [
		    	self.inputs.nixos-config
		    ];
		    nixpkgs.overlays = [
    			nixneovim.overlays.default
		    ];
		})
	    ];
	};
    };
  };
}
