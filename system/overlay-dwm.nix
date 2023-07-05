{ config, lib, pkgs, ... }:

let
  myDwm = pkgs.fetchFromGitHub {
    owner = "asifZaman0362";
    repo = "dwm";
    rev = "716574b091934c59ae4477cd6bb30b07da80632a";
    sha256 = "sha256-iPXX/ZUIJuOpd3KOHNBe9TaVVuftupp7Qiqt3laXOog=";
  };
in

{
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: { src = myDwm; });
    })
  ];
}
