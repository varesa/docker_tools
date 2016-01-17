#!/bin/env bash


if [ -z "$1" ]; then
	echo "Container name not provided"
	exit 1
fi

if [ -z "$2" ]; then
	echo "Destination  missing"
	exit 1
fi

if [ ! -d "$2" ]; then
	echo "Destination is not a directory"
	exit 1
fi

volumes=$(docker inspect --format='{{range $k,$v := .Config.Volumes}}{{printf "%s\n" $k}}{{end}}' $1)

if [ $? -eq 1 ]; then
	echo "Error. Invalid container name/ID?"
	exit 1
fi

if [ -z "$volumes" ]; then
	echo Container has no volumes
	exit 1
fi

for path in $volumes; do
	file=$(echo $path | sed 's:/:%2F:g').tar
	echo Copying $path
	docker run --rm -ti --volumes-from "$1" -v "$(readlink -f $2):/volume_export/" busybox tar -cf /volume_export/$file $path
done
