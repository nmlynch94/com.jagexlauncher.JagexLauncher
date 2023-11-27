#!/bin/bash
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub --user runtime/org.freedesktop.Platform.GL.default/x86_64/23.08 runtime/org.freedesktop.Platform.GL.default/x86_64/23.08-extra runtime/org.freedesktop.Platform.GL32.default/x86_64/23.08 runtime/org.freedesktop.Platform.ffmpeg-full/x86_64/23.08 runtime/org.freedesktop.Platform.ffmpeg_full.i386/x86_64/23.08 runtime/org.freedesktop.Platform.openh264/x86_64/2.2.0 org.gnome.Platform.Compat.i386//45 org.gnome.Platform.Locale//45 org.gtk.Gtk3theme.Breeze//3.22 org.gnome.Platform//45 org.winehq.Wine.DLLs.dxvk//stable-23.08 org.winehq.Wine.gecko//stable-23.08 org.winehq.Wine.mono//stable-23.08 && wget https://github.com/nmlynch94/com.jagexlauncher.JagexLauncher/releases/latest/download/jagexlauncher.flatpak && flatpak install --user jagexlauncher.flatpak -y && rm jagexlauncher.flatpak
