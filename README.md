# recommended directory structure #
Like with my other containers I encourage you to follow a unified directory structure approach to keep things simple & maintainable, e.g.:

```
project root
  - docker-compose.yaml
  - config
    - php70
      - fpm
        - php.ini (if needed)
        - conf.d
          - ...
  - htdocs
  - data
    - php70
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
   - ./htdocs:/app/htdocs
   - ./config/php70:/app/config
   - ./data/php70:/app/data
```

# Or start container manually #
```
docker run -d -P -t -i -p 9000:9000 \
	-v [local path to htdocs]:/app/htdocs \
    -v [local path to config]:/app/config \
    -v [local path to data]:/app/data \
	--name php qoopido/php70:latest
```

# Included modules #
```
php7.0
php7.0-fpm
php7.0-dev
php7.0-cli
php7.0-common
php7.0-intl
php7.0-bcmath
php7.0-mbstring
php7.0-soap
php7.0-xml
php7.0-zip
php7.0-apcu
php7.0-json
php7.0-gd
php7.0-curl
php7.0-mcrypt
php7.0-mysql
php7.0-sqlite
php-memcached
```

# Configuration #
Any files under ```/app/config``` will be symlinked into the container's filesystem beginning at ```/etc/php/7.0```. This can be used to overwrite the container's default php fpm configuration with a custom, project specific configuration.

If you need a custom shell script to be run on start or stop (e.g. to set symlinks) you can do so by creating the file ```/app/config/up.sh``` or ```/app/config/down.sh```.