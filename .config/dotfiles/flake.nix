{
  outputs = { ... }: {
    dotfiles = let root = ./../..; in with builtins; filterSource
      (path: type: all (p: path != toString (root + p)) [
        /.config/dotfiles/flake.nix
        /.gitignore
        /.gitmodules
        /Library
        /git
      ])
      root;
  };
}
