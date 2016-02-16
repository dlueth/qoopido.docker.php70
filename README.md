# recommended directory structure #
Like with my other containers I encourage you to follow a unified directory structure approach to keep things simple & maintainable, e.g.:

```
project root
  - docker_compose.yaml
  - config
    - php70
      - initialize.sh (if needed)
      - fpm
        - php.ini (if needed)
        - conf.d
          - ...
  - htdocs
  - sessions
  - logs
```

# Example docker-compose.yaml #
```
php:
  image: qoopido/php70:latest
  ports:
   - "9000:9000"
  volumes:
   - ./config:/app/config
   - ./htdocs:/app/htdocs
   - ./sessions:/app/sessions
   - ./logs:/app/logs
```

# Or start container manually #
```
docker run -d -P -t -i -p 9000:9000 \
	-v [local path to config]:/app/config \
	-v [local path to htdocs]:/app/htdocs \
	-v [local path to sessions]:/app/sessions \
	-v [local path to logs]:/app/logs \
	--name php qoopido/php70:latest
```

# Included modules #
```
php7.0-common
php7.0-json
php7.0-gd
php7.0-curl
php7.0-mcrypt
php7.0-mysql
php7.0-sqlite
php-memcached
```

# Configuration #
Any files under ```/app/config/php70``` will be symlinked into the container's filesystem beginning at ```/etc/php/7.0```. This can be used to overwrite the container's default php fpm configuration with a custom, project specific configuration.

If you need a custom shell script to be run on start (e.g. to set symlinks) you can do so by creating the file ```/app/config/php70/initialize.sh```.