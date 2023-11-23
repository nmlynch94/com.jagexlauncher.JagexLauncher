# Installing
### Release Bundle (easiest)
1. Download latest jagexlauncher.flatpak from the releases
2. Run `flatpak install --user jagexlauncher.flatpak` in the terminal

### Build and Install Locally

1. Only use this next command if it has already been installed and you want to run from scratch
`flatpak remove --delete-data com.jagex.Launcher`

2. Use these to build and run - you will need to install flatpak-builder from your package manager.
`flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo`
`flatpak-builder --install-deps-from=flathub --user --install --force-clean build-dir --disable-cache com.jagex.Launcher.yml`

3. NOTE: you should run this to make sure Compat.i386 is installed due to https://github.com/flathub/net.lutris.Lutris/issues/53
`flatpak install --user flathub org.gnome.Platform.Compat.i386//45`

4. Now, you can run the launcher from your application menu

# Maintenance
If there is a new update released, you need to update the metafile url in generate_sources.py and then run that script to generate the new sources. Eventually, the fingerprint for the certificate that was used to sign the jwt will also need to be changed out once it expires.

TODO: Add in automatic updates by polling that metafile periodically.

based on the work done in https://github.com/TormStorm/jagex-launcher-linux

