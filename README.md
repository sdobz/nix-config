# THEODORE's nix configuration

## Installation:

Was built for nix 19.09
Hardware considerations:
Note that enp33s0 is hardcoded to enable DHCP for a network device, 
To locate the new id run `find /sys/ | grep enp`
Note that BusID is unstable in xorg configuration, to find run nvidia-xconfig (may have to compile from source)

Depends on stable channel, though includes commented out kernel dep on unstable channel
Has home manager installed, link .config-nixpkgs to ~/.config/nixpkgs

Copy passwords.nix.example to passwords.nix and add 