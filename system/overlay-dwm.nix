{ config, lib, pkgs, ... }:

let
  myDwm = pkgs.fetchFromGitHub {
    owner = "asifZaman0362";
    repo = "dwm";
    rev = "master";
    sha256 = "sha256-NCsQLg1On4b83Z6bqym/l7HbXjpwS488MtJrVfpsbpI=";
  };
in

{
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: { src = myDwm; });
    })
  ];
}
