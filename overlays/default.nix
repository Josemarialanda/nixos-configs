{inputs, ...}: {
  # Custom packages from ./pkgs.
  additions = final: _prev: import ../pkgs final;

  # Overrides of nixpkgs packages, e.g.
  #   foo = prev.foo.overrideAttrs (old: { ... });
  modifications = final: prev: {};

  # Accessible through 'pkgs.unstable'.
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final.stdenv.hostPlatform) system;
      inherit (final) config;
    };
  };
}
