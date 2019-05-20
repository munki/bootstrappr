## Bootstrappr

A bare-bones tool to install a set of packages and scripts on a target volume.  
Typically these would be packages or scripts that "enroll" the machine into your management system; upon reboot these tools would take over and continue the setup and configuration of the machine.

Bootstrappr is designed to be able to run in Recovery mode, allowing you to "bootstrap" a machine fresh out of the box without having to run the Setup Assistant, manually creating a local account, and other unreliable manual tasks.

### Packages

Add desired packages to the `bootstrap/packages` directory. Ensure all packages you add can be properly installed to volumes other than the current boot volume.

If your packages just have payloads, they should work fine. Pre- and postinstall scripts need to be checked to not use absolute paths to the current startup volume. The installer system passes the target volume in the third argument `$3` to installation scripts.

### Scripts

Bootstrappr will check that script filenames end with the `.sh` extension and have the executable bit set. Other files will be ignored.

Bootstrappr passes the selected volume in the _first_ argument `$1` to scripts. (This is different from installation scripts in packages.)

Keep in mind that the Recovery system does not have the same set of tools available the full macOS has. `Python`, `ruby`, `zsh`, `osascript`, `systemsetup`, `networksetup` and many others are *not* available in the Recovery system, write your scripts accordingly. Using `bash` for your scripts is the safest choice.

If in doubt boot to Recovery and test.

### Order

Bootstrappr will work through scripts and packages in alphanumerical order. To control the order, you can prefix filenames with numbers.

#### iMac Pro

Bootstrappr is particularly useful with the new iMac Pro, which does not support NetBoot, and is tricky to get to boot from external media. To set up a new machine, you'd pull the machine out of the box, boot into Recovery (Command-R at start up), and mount the Bootstrappr disk and run Bootstappr.

### Usage scenarios

#### Scenario #1: USB Thumb drive

* Preparation:
  * Copy the contents of the bootstrap directory to a USB Thumb drive.
* Bootstrapping:
  * (Optional) Start up in Recovery mode.
  * Connect USB Thumbdrive.
  * Open Terminal (from the Utilities menu if in Recovery).
  * `/Volumes/VOLUME_NAME/run` (use `sudo` if not in Recovery)
  * If in Recovery, restart.

#### Scenario #2: Disk image via HTTP

* Preparation:
  * Create a disk image using the `make_dmg.sh` script.
  * Copy the disk image to a web server.
  * (https URLs may be problematic in Recovery mode. http URLs should be fine.)
* Bootstrapping:
  * (Optional) Start up in Recovery mode.
  * Open Terminal (from the Utilities menu if in Recovery).
  * `hdiutil attach <your_bootstrap_dmg_url>`
  * `/Volumes/bootstrap/run` (use `sudo` if not in Recovery)
  * If in Recovery, restart.


### Sample session

```
# hdiutil attach http://macbootstrap
/dev/disk3          	GUID_partition_scheme          	
/dev/disk3s1        	Apple_HFS                      	/Volumes/bootstrap
# /Volumes/bootstrap/run 
*** Welcome to bootstrappr! ***
Available volumes:
    1  Macintosh HD
    2  Target Volume
    3  bootstrap
Install to volume # (1-3): 2

Installing packages to /Volumes/Target Volume...
installer: Package name is foo
installer: Installing at base path /Volumes/Target Volume
installer: The install was successful.
installer: Package name is bar
installer: Installing at base path /Volumes/Target Volume
installer: The install was successful.
installer: Package name is baz
installer: Installing at base path /Volumes/Target Volume
installer: The install was successful.
installer: Package name is Munki - Managed software installation for OS X
installer: Installing at base path /Volumes/Target Volume
installer: The install was successful.

Packages installed. What now?
    1  Restart
    2  Shut down
    3  Quit
Pick an action # (1-3): 3
```
