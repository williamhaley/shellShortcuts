#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]];
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo ufw allow 32400/tcp
sudo ufw allow 1900/udp
sudo ufw allow 3005/tcp
sudo ufw allow 5353/udp
sudo ufw allow 8324/tcp
sudo ufw allow 32410/udp
sudo ufw allow 32412/udp
sudo ufw allow 32413/udp
sudo ufw allow 32414/udp
sudo ufw allow 32469/tcp

