#!/bin/sh

# Builds a disk image containing bootstrappr and packages.

THISDIR=$(/usr/bin/dirname ${0})
DMGNAME="${THISDIR}/bootstrap.dmg"
if [[ -e "${DMGNAME}" ]] ; then
    /bin/rm "${DMGNAME}"
fi
/usr/bin/hdiutil create -fs HFS+ -srcfolder "${THISDIR}/bootstrap" "${DMGNAME}"
