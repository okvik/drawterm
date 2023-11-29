{
  description = "Drawterm built with Zig Build";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
    zig-overlay.url = github:mitchellh/zig-overlay;
    zls.url = github:zigtools/zls;
  };

  outputs = { self, nixpkgs, zig-overlay, zls, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    zig = zig-overlay.packages.${system}.master;
    zlsPkg = zls.packages.${system}.zls;
  in {
    devShells.default = pkgs.mkShell {
      name = "drawterm-zig";

      packages =
        [ zig
          zlsPkg
        ] ++
        (with pkgs; [
        xorg.libX11
        xorg.libXt
        pipewire
        pkg-config
        ]);
    };
  });
}
