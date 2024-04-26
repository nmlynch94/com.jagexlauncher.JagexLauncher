#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

python3 "$SCRIPT_DIR"/../jagex-launcher-linux/resources/installer.py


JAGEX_EXE_NAME="JagexLauncher.exe"

wrestool -x --output=icon.ico -t14 "$JAGEX_EXE_NAME"
convert icon.ico icon.png
mkdir -p 256
mv icon-5.png 256/256.png

# Cleanup
ls -p | grep -v / | grep -v "extract_icons.sh" | xargs -n1 rm
rm -r locales