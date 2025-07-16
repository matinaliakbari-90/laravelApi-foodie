{ pkgs }:

pkgs.mkShell {
  buildInputs = [
    pkgs.php82
    pkgs.composer
    pkgs.mysql
    pkgs.git
    pkgs.nodejs_18
    pkgs.coreutils
  ];
}
