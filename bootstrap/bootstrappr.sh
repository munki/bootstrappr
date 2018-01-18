#!/bin/bash

# bootstrappr.sh
# A script to install packages and scripts found in a packages folder in the same directory
# as this script to a selected volume

if [[ $EUID != 0 ]] ; then
    echo "bootstrappr: Please run this as root, or via sudo."
    exit -1
fi

INDEX=0
OLDIFS=$IFS
IFS=$'\n'

echo "*** Welcome to bootstrappr! ***"
echo "Available volumes:"
for VOL in $(/bin/ls -1 /Volumes) ; do
    if [[ "${VOL}" != "OS X Base System" ]] ; then
        let INDEX=${INDEX}+1
        VOLUMES[${INDEX}]=${VOL}
        echo "    ${INDEX}  ${VOL}"
    fi
done
read -p "Install to volume # (1-${INDEX}): " SELECTEDINDEX

SELECTEDVOLUME=${VOLUMES[${SELECTEDINDEX}]}

if [[ "${SELECTEDVOLUME}" == "" ]]; then
    exit 0
fi

echo
echo "Installing packages to /Volumes/${SELECTEDVOLUME}..."

# dirname and basename not available in Recovery boot
# so we get to use Bash pattern matching
BASENAME=${0##*/}
THISDIR=${0%$BASENAME}
PACKAGESDIR="${THISDIR}packages"

for ITEM in "${PACKAGESDIR}"/* ; do
	FILENAME="${ITEM##*/}"
	EXTENSION="${FILENAME##*.}"
	if [[ -e ${ITEM} ]]; then
		case ${EXTENSION} in
			sh ) 
				if [[ -x ${ITEM} ]]; then
					echo "running script:  ${FILENAME}"
					# pass the selected volume to the script as $1
					${ITEM} "/Volumes/${SELECTEDVOLUME}"
				else
					echo "${FILENAME} is not executable"
				fi
				;;
			pkg ) 
				echo "install package: ${FILENAME}"
				/usr/sbin/installer -pkg "${ITEM}" -target "/Volumes/${SELECTEDVOLUME}"
				;;
			* ) echo "unsupported file extension: ${ITEM}" ;;
		esac
	fi
done

echo
echo "Packages installed. What now?"
echo "    1  Restart"
echo "    2  Shut down"
echo "    3  Quit"
read -p "Pick an action # (1-3): " WHATNOW

case $WHATNOW in
    1 ) /sbin/shutdown -r now ;;
    2 ) /sbin/shutdown -h now ;;
    3 ) echo ;;
esac
