## Bootstrappr

A bare-bones tool to install a set of packages on a target volume.  
Typically these would be packages that "enroll" the machine into your management system; upon reboot these tools would take over and continue the setup and configuration of the machine.

Add desired packages to the bootstrap/packages directory. Ensure all packages you add can be properly installed to volumes other than the current boot volume.

Bootstrappr is designed to be able to run in Recovery mode, allowing you to "bootstrap" a machine fresh out of the box without having to run the Setup Assistant, manually creating a local account, and other unreliable manual tasks.


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
* Bootstrapping:
  * (Optional) Start up in Recovery mode.
  * Open Terminal (from the Utilities menu if in Recovery).
  * `hdutil mount <your_bootstrap_dmg_url>`
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
```
