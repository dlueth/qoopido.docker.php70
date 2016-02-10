#!/bin/bash

INIT="/etc/php/7.0/initialize.sh"
files=($(find /app/config/php70 -type f))

for source in "${files[@]}" 
do
	pattern="\.DS_Store"
	target=${source/\/app\/config\/php70/\/etc\/php/7.0}
	
	if [[ ! $target =~ $pattern ]]; then
		if [[ -f $target ]]; then
			echo "    Removing \"$target\"" && rm -rf $target
		fi
		
		echo "    Linking \"$source\" to \"$target\"" && mkdir -p $(dirname "${target}") && ln -s $source $target
	fi
done

mkdir -p /app/htdocs
mkdir -p /app/sessions
mkdir -p /app/logs/php70

if [ -f $INIT ]
then
	 chmod +x $INIT && chmod 755 $INIT && eval $INIT;
fi