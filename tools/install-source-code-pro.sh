#!/usr/bin/env bash

#
# Debian install "Source Code Pro" font
#

[ -d /usr/share/fonts/opentype ] || sudo mkdir /usr/share/fonts/opentype

sudo git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/source-code-pro

sudo fc-cache -f -v
