#!/bin/bash

set -euo pipefail

VERSION=$1

cd ~/buildroot

make

mkdir -p \
~/hwlab/firmware/releases/$VERSION

cp output/images/* \
~/hwlab/firmware/releases/$VERSION/

sha256sum \
~/hwlab/firmware/releases/$VERSION/* \
> ~/hwlab/firmware/releases/$VERSION/checksums.sha256

echo "[+] Firmware build complete"