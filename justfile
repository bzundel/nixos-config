USERNAME := `whoami`
HOSTNAME := `hostname`

full: hm nixos

nixos:
	sudo nixos-rebuild switch --flake .#{{HOSTNAME}}

hm:
	home-manager switch --flake .#{{USERNAME}}@{{HOSTNAME}}

