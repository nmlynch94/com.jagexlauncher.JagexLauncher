# Disclaimer
I am in no way affiliated with Jagex and running the launcher through linux is unsupported by them. Any issues should be reported here as tickets. Use at your own risk.  
If you have any questions, Torm's Discord is the best place for this https://discord.gg/aX7GT2Mkdu.

# Installation Methods. Choose One Only.

### Repo (automated updates) - If you don't understand the other sections, this below command is the only one you need to run to get the launcher running.
- Open a terminal (konsole, etc)
- Run 
```
curl -fSsL https://raw.githubusercontent.com/nmlynch94/com.jagexlauncher.JagexLauncher/main/install-jagex-launcher-repo.sh | bash
```
- The Jagex Launcher will now show in your application menu or you can run with `flatpak run com.jagexlauncher.JagexLauncher`
- NOTE: The first run will take a bit due to the installation script. You will need to click update and then start the app again.
- To update, simply run `flatpak update` or update in an app store that supports flatpaks

### Release Bundle (no automated updates) - This option will be going away once the repo option is proven to be stable
- Here is a one liner to make sure all dependencies are installed and also install the latest release. This will likely take several minutes if flatpak is newly installed NOTE: First launch installs the launcher. It may appear to be doing nothing for a minute or two until it appears. It will be faster after that.
```
curl -fSsL https://raw.githubusercontent.com/nmlynch94/com.jagexlauncher.JagexLauncher/refs/heads/release-bundle/install-jagex-launcher-bundle.sh | bash
```
- The Jagex Launcher will now show in your application menu or you can run with `flatpak run com.jagexlauncher.JagexLauncher`
- NOTE: The first run will take a bit due to the installation script.
- To update, run the above script again

### Build Locally (no automated updates)
- Dependencies: `flatpak-builder`, `icoutils`, `imagemagick` 
- Clone the repo with submodules `git clone --recurse-submodules https://github.com/nmlynch94/com.jagexlauncher.JagexLauncher.git`
- `cd com.jagexlauncher.JagexLauncher`
- `cd icons && ./extract_icons.sh && cd ..`
- `flatpak-builder --install-deps-from=flathub --user --install --force-clean build-dir com.jagexlauncher.JagexLauncher.yml`

### Known Issues
- Dropdown menus in the launcher don't work in wine 10+. Click on the dropdown, then use arrow keys to select.
- On some hardware configurations, the RS3 launcher will show as a black screen. Right clicking will reveal it, and all the buttons will still work. Navigate using this trick and then it works fine once in game.

### If you have a steam deck
- Follow one of the methods above, then simply right click on the icon in the Application Menu and choose to create a steam shortcut. Then, you will be able to launch it in Game Mode.
- You may want to rename your shortcut to whatever you normally play (e.g. RuneLite, RuneScape, OSRS) because the way the deck searches community control schemes is by matching your game's name.
- For RuneLite users, there is a steamdeck-config.properties file placed in the data directory (usually in /var or ~/.var depening on if it's a user or system install). It will show in your file browser if you look for a folder called "data".
