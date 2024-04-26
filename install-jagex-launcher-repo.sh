#!/bin/bash
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user --if-not-exists JLauncher https://nmlynch94.github.io/com.jagexlauncher.JagexLauncher/JagexLauncher.flatpakrepo
flatpak install -y --user --noninteractive JLauncher com.jagexlauncher.JagexLauncher