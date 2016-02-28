#!/bin/bash

UP="/app/config/up.sh"

if [ -d /app/config ]
then
	files=($(find /app/config -type f))

	for source in "${files[@]}"
	do
		pattern="\.DS_Store"
		target=${source/\/app\/config/\/etc\/php/7.0}

		if [[ ! $target =~ $pattern ]]; then
			if [[ -f $target ]]; then
				echo "    Removing \"$target\"" && rm -rf $target
			fi

			echo "    Linking \"$source\" to \"$target\"" && mkdir -p $(dirname "${target}") && ln -s $source $target
		fi
	done
fi

mkdir -p /app/htdocs
mkdir -p /app/data/sessions
mkdir -p /app/data/logs
mkdir -p /app/config

if [ -f $UP ]
then
	echo "    Running startup script /app/config/up.sh"
	chmod +x $UP && chmod 755 $UP && eval $UP;
fi