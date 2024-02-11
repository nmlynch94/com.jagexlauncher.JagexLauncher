#!/bin/bash
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub --user runtime/org.freedesktop.Platform.GL.default/x86_64/23.08 runtime/org.freedesktop.Platform.GL.default/x86_64/23.08-extra runtime/org.freedesktop.Platform.GL32.default/x86_64/23.08 runtime/org.freedesktop.Platform.ffmpeg-full/x86_64/23.08 runtime/org.freedesktop.Platform.ffmpeg_full.i386/x86_64/23.08 runtime/org.freedesktop.Platform.openh264/x86_64/2.2.0 org.freedesktop.Platform.Compat.i386//23.08 org.freedesktop.Platform.Locale//23.08 org.gtk.Gtk3theme.Breeze//3.22 org.freedesktop.Platform//23.08 org.winehq.Wine.DLLs.dxvk//stable-23.08 org.winehq.Wine.gecko//stable-23.08 org.winehq.Wine.mono//stable-23.08 
curl -L https://github.com/nmlynch94/com.jagexlauncher.JagexLauncher/releases/latest/download/com.jagexlauncher.JagexLauncher.flatpak > com.jagexlauncher.JagexLauncher.flatpak
echo "Installing......."
flatpak install -y --user --noninteractive com.jagexlauncher.JagexLauncher.flatpak
echo "DONE"
