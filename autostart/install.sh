#!/bin/sh

install -m 755 docker-autostart.py /usr/local/bin/docker-autostart.py
install -m 644 docker-autostart.service /etc/systemd/system/docker-autostart.service
