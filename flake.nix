{
  description = "mango-shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = f: builtins.listToAttrs (map (system: {
      name = system;
      value = f system;
    }) systems);
  in {
    devShells = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            quickshell          
            wayland             
            wl-clipboard        
            grim slurp          
            jq yq-go            
          ];

          shellHook = ''
            export XDG_CONFIG_HOME="$PWD/config"
            export GIT_CONFIG_GLOBAL="$HOME/.config/git/config"
            mkdir -p "$XDG_CONFIG_HOME/quickshell"
          '';
        };
      });
  };
}

