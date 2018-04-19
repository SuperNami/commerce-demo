# from https://www.drupal.org/requirements/php#drupalversions
FROM registry.gitlab.com/dimages/php-72-drupal:latest

ENV PATH "$PATH:/var/www/html/vendor/bin"

# copy entrypoint
COPY entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

# copy build context
COPY . /var/www/html

# Install node v6 with npm
RUN apt-get update && \
    apt-get install -y gnupg1 gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs

# install drupal dependencies with composer
RUN cd /var/www/html && \
	composer install --no-dev && \
	cd web && \
	chown -R www-data:www-data sites modules themes && \
	cd themes/custom/lakunu_v01 && \
	npm install

WORKDIR /var/www/html
ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]