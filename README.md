# valenpkgs

`valenpkgs` is Valen's personal Nix flake: a focused collection of custom
derivations, an overlay, and a NixOS module. It targets `x86_64-linux` and
uses `nixpkgs` from the `nixos-26.05` branch.

## Packages

| Package | Description |
| --- | --- |
| `devilutionx` | DevilutionX 1.5.5, a modern Diablo engine build. It includes the upstream `spawn.mpq` Shareware data and starts without further setup. |
| `netui` | Network-management TUI provided by the upstream `netui` flake. Also available through the default overlay as `pkgs.valenpkgs.netui`. |
| `topmem` | CachyOS memory-monitoring utility. |
| `psa-update` | CLI for updating Stellantis infotainment systems. |
| `agopengps` | AgOpenGPS agricultural guidance application, packaged with Wine for x86_64 Linux. |
| `linux-rpi4-minimal` | Cross-built minimal headless Raspberry Pi 4 Linux kernel. |

### DevilutionX data

The default build installs the upstream Shareware `spawn.mpq` and wraps the
binary with its installed data directory. To play the retail game, provide
your legally obtained `DIABDAT.MPQ` in a directory you control and override
the data directory at launch:

```console
NIXPKGS_ALLOW_UNFREE=1 nix run --impure .#devilutionx -- \
  --data-dir /path/to/diablo-data
```

The retail game data is not distributed by this flake.

## NixOS Module

Import the default module, then enable the packages you want:

```nix
{
  imports = [ inputs.valenpkgs.nixosModules.default ];

  valenpkgs.devilutionx = {
    enable = true;
    enableShareware = true; # Default; installs spawn.mpq.
  };
}
```

`valenpkgs.devilutionx.enable` installs DevilutionX. Set
`valenpkgs.devilutionx.enableShareware` to `false` to omit `spawn.mpq`, for
example when supplying only retail data. The module also exposes boolean
options for `topmem`, `agopengps`, `psa-update`, and `linux-rpi4-minimal`.

## Usage and Integration

Add the flake input to a flake-based NixOS configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    valenpkgs.url = "git+ssh://git@git.valentinus.dev/valeninki/nixpkgs.git";
    valenpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Use an exported package directly in a configuration:

```nix
environment.systemPackages = [
  inputs.valenpkgs.packages.${pkgs.system}.netui
];
```

Run packages without installing them:

```console
nix run .#netui
NIXPKGS_ALLOW_UNFREE=1 nix run --impure .#devilutionx
```

DevilutionX is marked with its upstream Sustainable Use License, which Nix
treats as unfree. For imperative flake commands, use
`NIXPKGS_ALLOW_UNFREE=1` together with `--impure`. In NixOS, allow only this
package with:

```nix
nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg) [ "devilutionx" ];
```

To use the `netui` overlay instead of the package output:

```nix
nixpkgs.overlays = [ inputs.valenpkgs.overlays.default ];

environment.systemPackages = [ pkgs.valenpkgs.netui ];
```

## Development

The development shell provides `nixpkgs-fmt`, `statix`, and `deadnix`:

```console
nix develop
nix fmt
NIXPKGS_ALLOW_UNFREE=1 nix flake check --impure
```
