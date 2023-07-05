{ pkgs, ... }: {
	nixpkgs.overlays = [
		(import "${fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz"}/overlay.nix")
	];
}
