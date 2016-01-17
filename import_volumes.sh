#!/bin/env bash

function import {
	dir=$(readlink -f $(dirname $1))
	file=$(basename $1)
	echo "Importing $file from $dir"
	docker run --rm --volumes-from $2 -v $dir:/volume_import/ busybox tar xf /volume_import/$file
	
}

if [ -z "$1" ]; then
	echo "No source file/folder specified"
	exit 1
fi

if [ -z "$2" ]; then
	echo "No container specified as target"
	exit 1
fi

if [ -f "$1" ]; then
	echo "Importing single file: $1"
	import $1 $2
elif [ -d "$1" ]; then
	echo "Importing from directory: $1"
	for file in $1/*.tar
	do
		import $file $2
	done
else
	echo "Invalid source file/folder"
	exit 1
fi
