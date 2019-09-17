# Description
This repo contains reversed and restored sources for CP/M-80 OS (2.2) for Quorum computer. 

# What is Quorum?

This is computer, which was developed and factored in Ekaterinburg, Russia, and had wide use in this city and neighbor regions.

Quorum is one of numerous Russian ZX Spectrum clones, but it has major differences from other clones.
Firstly, it can turn on shadow RAM instead of ROM in lower 16k. Another feature is open access to the
ports of WD1793 (which is unusual for Betadisk128-inspired FDD controller).

These additions made this machine able to run CP/M-80, which was default OS for this computer.

# Goal of the project

My goal was to fix CPM 2.2 sources that way, so the resulting system image was equal to the original OS image from Quorum floppy. 
This has been achived. Bootable QDI disk image was [released](https://github.com/atsidaev/quorum-cpm/releases/download/v1.0/disk.qdi) 
and can be started in Quorum emulator (I use ZXMAK2).

# Information on Quorum CP/M-80
Some information is available in Russian on the [project wiki](https://github.com/atsidaev/quorum-cpm/wiki). CP/M programming manual is located there.
