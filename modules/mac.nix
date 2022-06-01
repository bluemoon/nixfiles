{ config, pkgs, lib, ... }: {

nix = {
  package = pkgs.nix;
  extraOptions = ''
    system = aarch64-darwin # M1 gang
    extra-platforms = aarch64-darwin x86_64-darwin # But we use rosetta too
    experimental-features = nix-command flakes
    build-users-group = nixbld
  '';
};
programs.fish.enable = true;
environment.shells = with pkgs; [ fish ];
users.users.bradford = {
  home = "/Users/bradford";
  shell = pkgs.fish;
};
}
