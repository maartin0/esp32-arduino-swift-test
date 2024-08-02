#!/usr/bin/env bash

# Installs ESP-IDF locally in ./esp-idf
# Tested on Linux, should work on Mac

IDF_VERSION="v5.1.4"

set -e

if [[ "$(uname -s)" =~ "Linux" ]]; then
    sudo apt-get update
	sudo apt-get install -y git wget flex bison gperf python3 python3-pip python3-venv cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0 python3-virtualenv
else
    # Probably on macos otherwise this should error instantly if brew isn't accessible
    brew install cmake ninja dfu-util ccache python3 virtualenv
	/usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

# Checkout to correct branch if already cloned to avoid having to re-download
if [ -d "esp-idf" ]; then
    cd esp-idf
    git checkout "${IDF_VERSION}"
    cd ..
else
    git clone -b "${IDF_VERSION}" --recursive https://github.com/espressif/esp-idf.git esp-idf
fi

# Use python3 alias if installed as "python"
if ! declare -F "python3" > /dev/null; then
    alias python3=python
fi

./esp-idf/install.sh
. ./esp-idf/export.sh
python3 -m pip install -r requirements.txt
