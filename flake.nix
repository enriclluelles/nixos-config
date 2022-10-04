{
  description = "NixOS configuration with two or more channels";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-22_05.url = "nixpkgs/nixos-22.05";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-22_05,
    neovim-nightly-overlay,
    home-manager,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) nixosSystem;

    system = "x86_64-linux";
    overlay-22_05 = final: prev: {
      stable-22_05 = import nixpkgs-22_05 {
        inherit system;
        config.allowUnfree = true;
      };
    };

    customoverlay = final: prev: {
      slack = prev.slack.overrideAttrs (finalAttrs: prevAttrs: {
        installPhase = ''
          runHook preInstall
          # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
          dpkg --fsys-tarfile $src | tar --extract
          rm -rf usr/share/lintian
          mkdir -p $out
          mv usr/* $out
          # Otherwise it looks "suspicious"
          chmod -R g-w $out
          for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
            patchelf --set-rpath ${prevAttrs.rpath}:$out/lib/slack $file || true
          done
          # Replace the broken bin/slack symlink with a startup wrapper.
          # Make xdg-open overrideable at runtime.
          rm $out/bin/slack
          makeWrapper $out/lib/slack/slack $out/bin/slack \
            --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
            --suffix PATH : ${prev.lib.makeBinPath [prev.xdg-utils]} \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer}}"
          # Fix the desktop link
          substituteInPlace $out/share/applications/slack.desktop \
            --replace /usr/bin/ $out/bin/ \
            --replace /usr/share/ $out/share/
          runHook postInstall
        '';
      });
    };

    overlays = [
      overlay-22_05
      neovim-nightly-overlay.overlay
      customoverlay
    ];
  in {
    nixosConfigurations."xps15" = nixosSystem {
      inherit system;
      modules = [
        # Overlays-module makes "pkgs.stable-22_05" available in configuration.nix
        ({
          config,
          pkgs,
          ...
        }: {nixpkgs.overlays = overlays;})
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.enric = import ./enric.nix;
          home-manager.extraSpecialArgs = {};
        }
      ];
    };
  };
}
