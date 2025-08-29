#!/bin/sh
set -e
# create pixmap dir and copy icon (paths already created earlier)
gtk-update-icon-cache -f -t /usr/share/icons/hicolor || true
# ensure installer desktop icon is present
cp /usr/share/pixmaps/furrydistro.svg /usr/share/applications/install-furrydistro.png 2>/dev/null || true

