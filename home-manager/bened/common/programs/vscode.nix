{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      elixir-lsp.vscode-elixir-ls
      bradlc.vscode-tailwindcss
      stefanjarina.vscode-eex-snippets
    ];
  };
}
