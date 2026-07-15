{ pkgs }:

let
  patchVst3 =
    {
      name,
      sha256,
      extraLibs ? [ ],
    }:
    let
      commonLibs = with pkgs; [
        fontconfig
        freetype
        stdenv.cc.cc.lib
      ];
      allLibs = commonLibs ++ extraLibs;
    in
    pkgs.stdenv.mkDerivation {
      inherit name;
      src = pkgs.requireFile {
        name = "${name}.so";
        sha256 = sha256;
        message = ''
          This plugin is not in the Nix store. Run:
            nix-store --add-fixed sha256 ~/.vst3/${name}.vst3/Contents/x86_64-linux/${name}.so
        '';
      };

      nativeBuildInputs = [ pkgs.patchelf ];
      buildInputs = allLibs;

      unpackPhase = "true"; # skip — src is a single .so file

      installPhase = ''
        mkdir -p $out/lib/vst3/${name}.vst3/Contents/x86_64-linux
        cp $src $out/lib/vst3/${name}.vst3/Contents/x86_64-linux/${name}.so
        chmod +w $out/lib/vst3/${name}.vst3/Contents/x86_64-linux/${name}.so
        patchelf \
          --set-rpath "${pkgs.lib.makeLibraryPath allLibs}" \
          $out/lib/vst3/${name}.vst3/Contents/x86_64-linux/${name}.so
      '';
    };
in
{
  Polarity-MD = patchVst3 {
    name = "Polarity-MD";
    sha256 = "4db8f0a0e3b2db0725452ed0f06aaeeb497e49a865d81fda1b6ff2d75ea80f18"; # paste hash here
  };

  Polarity-SC-Dark = patchVst3 {
    name = "Polarity-SC-Dark";
    sha256 = "4a7a8db99f555cc97169a65b8f43c44d42775302052238ef99719a14d1e50832"; # paste hash here
    extraLibs = with pkgs; [
      wayland
      libxcb-wm
      xorg.libxcb
      xorg.libX11
      libGL
    ];
  };
}
