#!/usr/bin/env bash

VERSION="${VERSION:-"latest"}"

set -eux

# Clean up
rm -rf /var/lib/apt/lists/*

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}


# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

# Install dependencies
check_packages curl tar wget ca-certificates

if [ "${VERSION}" = "latest" ]; then
    VERSION="$(curl --silent "https://api.github.com/repos/errata-ai/vale/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')"
fi

echo "Version is ${VERSION}"

# download vale & install it
arch="$(arch | sed s/aarch64/arm64/ | sed s/x86_64/64-bit/)"
wget "https://github.com/errata-ai/vale/releases/download/v${VERSION}/vale_${VERSION}_Linux_${arch}.tar.gz"
mkdir bin && tar -xvzf "vale_${VERSION}_Linux_${arch}.tar.gz" -C bin
mv ./bin/vale /usr/bin

# clean up
rm -rf "vale_${VERSION}_Linux_${arch}.tar.gz"
rm -rf ./bin

echo "Done!"
