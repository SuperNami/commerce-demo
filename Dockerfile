# from https://www.drupal.org/requirements/php#drupalversions
FROM registry.gitlab.com/dimages/php-71-drupal:latest

ENV PATH "$PATH:/var/www/html/vendor/drush/drush"

# copy entrypoint
COPY entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

# copy build context
COPY . /var/www/html

# Install node v6 with npm
RUN apt-get update && \
    apt-get install -y gnupg && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs

# install drupal dependencies with composer
RUN cd /var/www/html && \
		composer install --no-interaction --no-dev && \
		cd web && \
		chown -R www-data:www-data sites modules themes && \
		cd themes/custom/commerce_2_demo && \
		npm install && \
		npm install --global gulp-cli && \
		gulp sass

WORKDIR /var/www/html
ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]