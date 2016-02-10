# Build container #
```
docker build -t qoopido/php70:1.0.0 .
```

# Run container manually ... #
```
docker run -d -P -t -i -p 9000:9000 -p 9001:9001 \
	-v [local path to apache htdocs]:/app/htdocs \
	-v [local path to logs]:/app/logs \
	-v [local path to sessions]:/app/sessions \
	-v [local path to config]:/app/config \
	--name php qoopido/php70
```

# ... or use docker-compose #
```
php:
  image: qoopido/php70
  ports:
   - "9000:9000"
   - "9001:9001"
  volumes:
   - ./htdocs:/app/htdocs
   - ./logs:/app/logs
   - ./sessions:/app/sessions
   - ./config:/app/config
```

# Open shell #
```
docker exec -i -t "php" /bin/bash
```

# Project specific configuration #
Any files under ```/app/config/php70``` will be symlinked into the container's filesystem beginning at ```/etc/php/7.0```. This can be used to overwrite the container's default php fpm configuration with a custom, project specific configuration. Beside adjusting the php.ini this can also be used to enable xDebug (which is disabled by default) with the following content in ```/app/config/php70/fpm/conf.d/20-xdebug.ini```

If you need a custom shell script to be run on start (e.g. to set symlinks) you can do so by creating the file ```/app/config/php70/initialize.sh```.

```
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_port="9001"
xdebug.remote_connect_back=1
```