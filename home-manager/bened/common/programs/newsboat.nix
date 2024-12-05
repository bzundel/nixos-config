{ pkgs, ... }:
{
  home.packages = [
    pkgs.newsboat
  ];
  
  programs.newsboat = {
    enable = true;

    urls = [
      {
        # hackernews
        tags = [ "tech" ];
        url = "https://hnrss.org/frontpage";
      }
      {
        # tagesschau
        tags = [ "news" ];
        url = "https://www.tagesschau.de/index~rss2.xml";
      }
    ];

    extraConfig = ''
      auto-reload yes

      unbind-key ENTER
      unbind-key j
      unbind-key k
      unbind-key J
      unbind-key K

      bind-key j down
      bind-key k up
      bind-key l open
      bind-key h quit
    '';
  };
}
