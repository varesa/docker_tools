#!/bin/env python

import sys
import subprocess
import json

if len(sys.argv) < 2:
	print("Need container name/ID")
	sys.exit(1)

if len(sys.argv) > 2:
	new_name = sys.argv[2]
else:
	new_name = None

CID = sys.argv[1]
container_json = subprocess.check_output(['docker', 'inspect', CID])
container = json.loads(container_json)[0]

name = container['Name'][1:]

if not new_name:
	new_name = name #+ "-2"

port_bindings = container['HostConfig']['PortBindings']

mounts = []
for mount in container['Mounts']:
	if not '/var/lib/docker' in mount['Source']:
		mounts.append(mount)

env = container['Config']['Env']

image = container['Config']['Image']
cmd = container['Config']['Cmd']
if not cmd:
	cmd = ""

run =  "docker run"
run += " --name " + new_name
run += " -d"

for port in port_bindings:
	hostport = port_bindings[port][0]['HostPort']
	if hostport:
		run += " -p " + hostport + ":" + port
	else:
		run += " -p " + port

for vol in mounts:
	run += " -v " + vol['Source'] + ":" + vol['Destination']

if new_name != name:
	run += " --volumes-from " + name

for var in env:
	if var.startswith("PATH="):
		continue
	else:
		run += " -e \"" + var + "\""

run += " " + str(image) + " " + ' '.join(cmd)

print(run)
