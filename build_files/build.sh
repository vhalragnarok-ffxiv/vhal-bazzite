#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

chmod 0755 /usr/local/bin/unityhub-bazzite

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# Install Unity & .NET SDK
dnf5 install -y unityhub dotnet-sdk-10.0

# Get our fixed Unity Hub .desktop file in-place
install -Dm0644 \
    /ctx/system_files/usr/share/applications/unityhub.desktop \
    /usr/share/applications/unityhub.desktop

#Jetbrains Toolbox!
# Install latest JetBrains Toolbox
mkdir -p /opt/jetbrains-toolbox

curl -fL --retry 3 \
    "https://data.services.jetbrains.com/products/download?code=TBA&platform=linux" \
    -o /tmp/jetbrains-toolbox.tar.gz

tar -xzf /tmp/jetbrains-toolbox.tar.gz \
    -C /opt/jetbrains-toolbox \
    --strip-components=1

rm -f /tmp/jetbrains-toolbox.tar.gz

ln -sf \
    /opt/jetbrains-toolbox/bin/jetbrains-toolbox \
    /usr/local/bin/jetbrains-toolbox

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
