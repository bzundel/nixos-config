#!/usr/bin/env sh

xsetroot -solid '#000000'
syndaemon -i 1.0 -K -R -d
sxhkd &
slstatus &
