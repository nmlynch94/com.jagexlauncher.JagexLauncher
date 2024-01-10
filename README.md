# Disclaimer
I am in no way affiliated with Jagex and running the launcher through linux is unsupported by them. Any issues should be reported here as tickets. Use at your own risk.

# Installation Methods (This is not available on Flathub due to them not allowing Wine applications)
### Release Bundle (easiest) - If you don't understand the other sections, this below command is the only one you need to run to get the launcher running.
- Here is a one liner to make sure all dependencies are installed and also install the latest release. This will likely take several minutes if flatpak is newly installed NOTE: First launch installs the launcher. It may appear to be doing nothing for a minute or two until it appears. It will be faster after that.
```
curl -fSsL https://raw.githubusercontent.com/nmlynch94/com.jagexlauncher.JagexLauncher/main/install-jagex-launcher.sh | bash
```
- OPTIONAL: You can also do it manually, but just make sure you run the flatpak install command from the script in this repo to make sure you have all the correct dependencies.
NOTE: The reason explicitly installing the dependencies above is necessary is due to a bug where dependency flatpaks are not installed properly for flatpaks installed from non-flathub sources. 

### Build and Install Locally

1. Only use this next command if it has already been installed and you want to run from scratch. This will wipe out all saved settings.
```
flatpak remove --delete-data com.jagexlauncher.JagexLauncher
```

2. Use these to build and run - you will need to install flatpak-builder from your package manager.
```
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak-builder --install-deps-from=flathub --user --install --force-clean build-dir --disable-cache com.jagexlauncher.JagexLauncher.yml
flatpak install --user flathub org.gnome.Platform.Compat.i386//45
```
4. NOTE: The additional flatpak install command above is to make sure Compat.i386 is installed due to https://github.com/flathub/net.lutris.Lutris/issues/53
5. Now, you can run the launcher from your application menu

### If you have a steam deck
- Follow one of the methods above, then simply right click on the icon in the Application Menu and choose to create a steam shortcut. Then, you will be able to launch it in Game Mode.
- You may want to rename your shortcut to whatever you normally play (e.g. RuneLite, RuneScape, OSRS) because the way the deck searches community control schemes is by matching your game's name.
- I recommend the release bundle method especially, because the flatpak-builder method will require you to disable your Read Only partition in order to install flatpak-builder https://steamdecki.org/SteamOS/Read-only_Filesystem. I don't recommend doing this unless you are familiar enough with Linux to know you can ignore this warning.
- For RuneLite users, there is a steamdeck-config.properties file placed in the data directory (usually in /var or ~/.var depening on if it's a user or system install). It will show in your file browser if you look for a folder called "data".

### Updates
To update, you can simply follow one of the above installation instructions on the latest code/release. The Jagex Launcher itself will be able to self-update, so the only reason you will need to do that is to get bugfixes or newer RuneLite or HDOS versions. 

based on the work done in https://github.com/TormStorm/jagex-launcher-linux

