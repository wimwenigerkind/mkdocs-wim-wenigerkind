{ pkgs, ... }:

{
  packages = with pkgs; [
    git
    python3
    python3Packages.mike
    python3Packages.mkdocs
    python3Packages.mkdocs-material
    # Falls weitere Extensions gebraucht werden:
    python3Packages.pymdown-extensions
  ];
}