FROM qoopido/base:latest
MAINTAINER Dirk Lüth <info@qoopido.com>

# Initialize environment
	CMD ["/sbin/my_init"]
	ENV DEBIAN_FRONTEND noninteractive

# install language pack required to add PPA
	RUN apt-get update \
		&& apt-get install -qy language-pack-en-base \
		&& locale-gen en_US.UTF-8
	ENV LANG en_US.UTF-8
	ENV LC_ALL en_US.UTF-8

# add PPA for PHP 7
	RUN add-apt-repository ppa:ondrej/php

# install packages
	RUN apt-get update \
		&& apt-get install -qy \
			php7.0 \
			php7.0-fpm \
			php7.0-dev \
			php7.0-cli \
			php7.0-common \
			php7.0-intl \
			php7.0-bcmath \
			php7.0-mbstring \
			php7.0-soap \
			php7.0-xml \
			php7.0-zip \
			php7.0-apcu \
			php7.0-json \
			php7.0-gd \
			php7.0-curl \
			php7.0-mcrypt \
			php7.0-mysql \
			php7.0-sqlite \
			php-memcached
			
# generate locales
	RUN cp /usr/share/i18n/SUPPORTED /var/lib/locales/supported.d/local \
		&& locale-gen

# install composer
	RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
		&& php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
		&& php composer-setup.php \
		&& php -r "unlink('composer-setup.php');"

# configure defaults
	COPY configure.sh /
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
    	mkdir -p /app/data/sessions && \
    	mkdir -p /app/data/logs && \
    	mkdir -p /app/config

# cleanup
	RUN apt-get -qy autoremove \
		&& deborphan | xargs apt-get -qy remove --purge \
		&& rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /usr/share/doc/* /usr/share/man/* /tmp/* /var/tmp/* /configure.sh \
		&& find /var/log -type f -name '*.gz' -exec rm {} + \
		&& find /var/log -type f -exec truncate -s 0 {} +

# finalize
	VOLUME ["/app/htdocs", "/app/data", "/app/config"]
	EXPOSE 9000
	EXPOSE 9001
