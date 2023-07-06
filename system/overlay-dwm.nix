{ config, lib, pkgs, ... }:

let
  myDwm = pkgs.fetchFromGitHub {
    owner = "asifZaman0362";
    repo = "dwm";
    rev = "master";
    sha256 = "sha256-5F6zF+qSD3jLT+WglV91ZJZRKmtJ704xzMCCud3O+j0=";
  };
in

{
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: { src = myDwm; });
    })
  ];
}
