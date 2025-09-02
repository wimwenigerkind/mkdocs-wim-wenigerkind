{ pkgs, ... }:

{
  packages = with pkgs; [
    git
    python3
    python3Packages.mike
    python3Packages.mkdocs
    python3Packages.mkdocs-material
    python3Packages.mkdocs-git-revision-date-localized-plugin
    python3Packages.mkdocs-git-committers-plugin-2
    # Falls weitere Extensions gebraucht werden:
    python3Packages.pymdown-extensions
  ];
}