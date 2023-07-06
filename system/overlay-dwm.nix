{ config, lib, pkgs, ... }:

let
  myDwm = pkgs.fetchFromGitHub {
    owner = "asifZaman0362";
    repo = "dwm";
    rev = "master";
    sha256 = "sha256-eRPbUGYngDJ9cLBbqs/k9hh3MUiUcUkNraOotnq/VDE=";
  };
in

{
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: { src = myDwm; });
    })
  ];
}
