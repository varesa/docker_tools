#!/bin/sh

if [ $# != 1 ]
then
	echo "Usage: $0 <container name>"
	exit 1
fi

cat <<END
[Unit]
Description=$1 (container)
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a $1
ExecStop=/usr/bin/docker stop -t 2 $1

[Install]
WantedBy=local.target
END
