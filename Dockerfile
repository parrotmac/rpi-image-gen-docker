FROM debian:trixie

RUN apt-get update && \
	apt-get install -y \
	sudo git \
	python-is-python3 python3-yaml python3-debian dpkg-dev dbus-user-session \
	mmdebstrap podman uidmap zip dosfstools e2fsprogs rsync curl mtools pv btrfs-progs dctrl-tools uuid-runtime fdisk python3-jsonschema cryptsetup python3-pip autoconf automake libtool autopoint flex gettext pkg-config libpam-runtime

COPY <<EOF /etc/apt/sources.list.d/rpi.sources
Types: deb
URIs: http://raspbian.raspberrypi.org/raspbian/
Suites: trixie
Components: main contrib non-free rpi
Signed-By: /etc/apt/keyrings/raspbian-archive-keyring.gpg

Types: deb
URIs: http://archive.raspberrypi.org/debian/
Suites: trixie
Components: main
Signed-By: /etc/apt/keyrings/raspberrypi-archive-keyring.gpg
EOF

RUN curl -fsSL https://archive.raspberrypi.org/debian/raspberrypi.gpg.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/raspberrypi-archive-keyring.gpg > /dev/null

RUN curl -fsSL https://archive.raspbian.org/raspbian.public.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/raspbian-archive-keyring.gpg > /dev/null

RUN mkdir -p /etc/crypto-policies/back-ends

RUN 
COPY <<EOF /etc/crypto-policies/back-ends/sequoia.config
[hash_algorithms]
sha1 = "always"

[asymmetric_algorithms]
rsa1024 = "always"
EOF

RUN apt-get install --reinstall debian-archive-keyring

