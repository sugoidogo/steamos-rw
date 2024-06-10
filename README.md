# SteamOS-RW
Use pacman without breaking SteamOS
<!--download button goes here-->
## Usage
1. Make sure your sudo password is set (use the `passwd` command in Konsole if not)
2. Download the `.desktop` file above and open it in your file manager to start the install

Once installed, you can use the `steamos-rw` command to enable, disable, or reset your writeable overlay.
## Details
The overlay data is stored in a disk image at `/home/.steamos/offload/usr.img` alongside the rest of the SteamOS offload folders.
That disk image is mounted to `/var/lob/overlays/usr` alongside the `etc` overlay folder (`var-lib-overlay-usr.mount`).
Finally, overlayfs is used the same way as SteamOS does with the `etc` overlay to enable writing to the `usr` folder (`usr.mount`), which allows you to use pacman.
Additionally, all the pre-installed packages are added to the pacman `IgnorePkg` list (`/etc/pacman.conf`) to prevent you from borking your system with a `pacman -Syu`.
Next, the default mirrorlist (`/etc/pacman.d/mirrorlist`) has to have `SigLevel = Optional TrustAll` added to work at all, thanks to valve somehow breaking package/repo signing.
After initializing the pacman keyring, `pacman-contrib` is installed to get the `paccache` service, which will help prevent pacman cache from filling up the small `/var` partition.
To get systemd services like tailscale working, a system and user service (`overlay-units.service`) is added to issue start commands to enabled services, since they show up in the system too late for systemd to automatically start them.
Finally, `steamos-rw.target` and the `steamos-rw` command allow you to easily control the overlay.
You can also use `steamos-rw reset` to re-format the overlay disk image if you'd like to reset your installed software.