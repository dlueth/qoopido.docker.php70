FROM phusion/baseimage:latest
MAINTAINER Dirk Lüth <info@qoopido.com>

# Initialize environment
	CMD ["/sbin/my_init"]
	ENV DEBIAN_FRONTEND noninteractive

# based on dgraziotin/docker-osx-lamp
	ENV DOCKER_USER_ID 501 
	ENV DOCKER_USER_GID 20
	ENV BOOT2DOCKER_ID 1000
	ENV BOOT2DOCKER_GID 50

# Tweaks to give Apache/PHP write permissions to the app
	RUN usermod -u ${BOOT2DOCKER_ID} www-data && \
    	usermod -G staff www-data && \
    	groupmod -g $(($BOOT2DOCKER_GID + 10000)) $(getent group $BOOT2DOCKER_GID | cut -d: -f1) && \
    	groupmod -g ${BOOT2DOCKER_GID} staff

# install language pack required to add PPA
	RUN apt-get update && \
		apt-get -qy upgrade && \
		apt-get -qy dist-upgrade && \
		apt-get install -qy language-pack-en-base && \
		locale-gen en_US.UTF-8
	ENV LANG en_US.UTF-8
	ENV LC_ALL en_US.UTF-8

# add PPA for PHP 7
	RUN sudo add-apt-repository ppa:ondrej/php

# install packages
	RUN apt-get update && \
		apt-get install -qy php7.0-fpm \
			php7.0-common \
			php7.0-json \
			php7.0-gd \
			php7.0-curl \
			php7.0-mcrypt \
			php7.0-mysql \
			php7.0-sqlite \
			php-memcached
			
# generate locales
	RUN cp /usr/share/i18n/SUPPORTED /var/lib/locales/supported.d/local && \
		locale-gen

# configure defaults
	ADD configure.sh /configure.sh
	ADD config /config
	RUN chmod +x /configure.sh && \
		chmod 755 /configure.sh
	RUN /configure.sh && \
		chmod +x /etc/my_init.d/*.sh && \
		chmod 755 /etc/my_init.d/*.sh && \
		chmod +x /etc/service/php70/run && \
		chmod 755 /etc/service/php70/run
		
# enable extensions

# disable extensions

# add default /app directory
	ADD app /app
	RUN mkdir -p /app/htdocs && \
		mkdir -p /app/sessions && \
		mkdir -p /app/logs/php70

# cleanup
	RUN apt-get clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /configure.sh

# finalize
	VOLUME ["/app/htdocs", "/app/logs", "/app/sessions", "/app/config"]
	EXPOSE 9000
	EXPOSE 9001
