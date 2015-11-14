#!/bin/env python

import sys
import subprocess
import os

if len(sys.argv) < 2:
	print("No container name given")
	sys.exit(1)

FNULL = open(os.devnull, "w")

def container_exists(name):
	code = subprocess.call(['docker', 'inspect', name], stdout=FNULL, stderr=FNULL)
	if code == 0:
		return True
	else:
		return False

def docker_call(args, output=False):
	if output:
		stdout=None
	else:
		stdout=FNULL
	return subprocess.call(['docker'] + args, stdout=stdout)

## Check starting state

print("Checking")

name = sys.argv[1]

if not container_exists(name):
	print("Container " + name + " doesn't exist")
	sys.exit(1)

backup_name = name + "_backup"

if container_exists(backup_name):
	print("Container " + backup_name + " already exists, can't operate")
	sys.exit(1)

## Pull latest image

print("Pulling new image")

image = subprocess.check_output(['docker', 'inspect', '--format="{{.Config.Image}}"', name]).strip()
docker_call(['pull', image], output=True)

## Do the switching

print("Stopping old container")
docker_call(['stop', name])
print("Renaming old container")
docker_call(['rename', name, backup_name])
print("Starting new container:")
create_cmd = subprocess.check_output(['dgetcmd.py', backup_name, name])
create_cmd_split = [arg.strip('"\n') for arg in create_cmd.split(' ')]
print(create_cmd)
subprocess.call(create_cmd_split)

print('New container ' + name + " running. You may wish to remove " + backup_name)
