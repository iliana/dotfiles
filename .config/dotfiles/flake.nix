{
  outputs = { ... }: {
    packages.x86_64-linux.default =
      let
        root = ./../..;
      in
      with builtins; filterSource
        (path: type: all (p: path != toString (root + p)) [
          /.config/dotfiles/flake.nix
          /git
          /Library
        ])
        root;
  };
}
