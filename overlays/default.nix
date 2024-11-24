{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = final: prev: {
  # example:
  #    # Run Alpaca with GPU (AMD) acceleration enabled 
  #    # Accessible through pkgs.alpaca
  #    alpaca = final.unstable.alpaca.overrideAttrs (oldAttrs: rec {
  #      ollama = final.unstable.ollama-rocm;
  #    });
  };
  # Accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
