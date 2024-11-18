{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userEmail = "benedikt.zundel@live.com";
    userName = "Benedikt Zundel";

    extraConfig = {
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      pull.rebase = false;
      core.editor = "vim";
    };
  };
}
