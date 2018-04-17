# The original Comix Cursors sources README

The official ComixCursors releases can be found on gitlab.com:
<https://gitlab.com/limitland/comixcursors>


INSTALLATION
------------

Refer to the ‘INSTALL’ file for requirements and detailed instructions
to build and install.

If you want to use "NOHAIR" cursors, that is no hairline in the text-, vertical-text- and
crosshair-cursors, checkout the NOHAIR branch. We will keep this branch synchronized
with the master. 

COPYRIGHT
---------

Refer to the ‘COPYING’ file for copyright statement and grant of
license.


KNOWN ISSUES
------------

* nVIDIA graphics cards:

  If you experience the cursor shadow looking strange, e.g. with the i
  christmas theme, or the whole cursor appear gray when it's supposed to be
  white, disable hardware cursor rendering.

  In the xorg.conf file in the device section insert the HWCursor line
  below::

      Section "Device"
      Driver "nvidia"
      ...
      Option "HWCursor" "off"
      EndSection

* If you are using KDE version prior to 4.0 you might experience that
  KDE's control center Mouse Theme Installation does not support symlinks
  in the packed archives (tar). Consider updating KDE.

* Gnome supports multiple cursor sizes in one cursor theme, but only
  distinct sizes: 16, 24, 32, and 48 pixels.

  There is no known Gnome 3 application for setting the size of the mouse
  cursor. You need to set the desired size in pixels as the value of the
  DConf setting ‘org.gnome.desktop.interface.cursor-size’. You can use
  ‘dconf-editor’ (from the ‘dconf-tools’ package) or ‘gsettings’ to change
  DConf settings.

* If you are missing some cursors issue "# export XCURSOR_DISCOVER=1"
  and re-start the application to find the corresponding cursor hash.
  Report it to us or link it yourself in the ~/.icons directory.


NAMING CURSORS
--------------

See the file CURSORNAMES.md for details.

..
    Local variables:
    coding: utf-8
    mode: text
    mode: rst
    End:
    vim: fileencoding=utf-8 filetype=rst :
