{ config, lib, pkgs, ... }:

let
  myDwm = pkgs.fetchFromGitHub {
    owner = "asifZaman0362";
    repo = "dwm";
    rev = "master";
    sha256 = "sha256-xHxdtb0hi9If/whLXNp+xL3BowxNRNQGEzSE+3p30QI=";
  };
in

{
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: { src = myDwm; });
    })
  ];
}
