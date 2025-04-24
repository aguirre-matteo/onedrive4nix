{
  description = "OneDrive Client for Linux";

  outputs =
    { self, ... }:
    {
      homeManagerModule = import ./module.nix;
    };
}
