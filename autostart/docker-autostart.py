#!/bin/env python

import time
import subprocess


print("Starting")

try:
    with open("/etc/docker-autostart.conf", "r") as f:
        for line in f:
            if line.startswith("#"):
                continue  # Comment
            if line.startswith("w "):
                delay = int(line[2:])
                time.sleep(delay)
            else:
                subprocess.call(['docker', 'start', line.strip()])
except IOError:
    with open("/etc/docker-autostart.conf", "w") as f:
        f.write("#List of containers to start\n")
        f.write("w 10\n")

while True:
    time.sleep(10)
