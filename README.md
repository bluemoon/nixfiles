# nixfiles

To install nix:

```bash
$ curl -L https://nixos.org/nix/install | sh
$ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
```


To install (probably should put this in nix itself?):

- install zoxide
- install yabai
- install skhd
