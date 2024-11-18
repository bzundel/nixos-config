{
  programs.gnome-terminal = {
    enable = true;

    profile."d389d7f9-374e-49ad-9230-09407436358f" = {
      default = true;
      visibleName = "Default";
      allowBold = true;
      audibleBell = false;
      boldIsBright = true;
      font = "Ubuntu Mono Bold 12";
    };
  };
}
