#!/usr/bin/env bash
set -euo pipefail

docker build -t rpi-image-gen .

docker run --rm --name rpi-image-gen \
	--privileged \
	-v $(pwd)/config:/config \
	-v $(pwd)/out:/out \
	rpi-image-gen \
	/bin/bash -c 'cd /opt && git clone https://github.com/raspberrypi/rpi-image-gen.git && cd rpi-image-gen && ./rpi-image-gen build -S /config/webkiosk/ -c kiosk.yaml &&  cp -a ./work/deploy-* /out'

