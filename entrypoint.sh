#!/bin/bash

set -e

if ! [ -e "/var/www/html/web/sites/default/settings.local.php" ]; then

  export DB_NAME=${DB_NAME}
  export DB_USER=${DB_USER}
  export DB_PASSWORD=${DB_PASSWORD}
  export DB_HOST=${DB_HOST}
  export DB_PORT=${DB_PORT}

  cp /var/www/html/web/sites/example.settings.php /var/www/html/web/sites/default/settings.local.php
  rm /var/www/html/web/sites/example.settings.php

  sed -i "s/dbname/${DB_NAME}/" /var/www/html/web/sites/default/settings.local.php
  sed -i "s/dbuser/${DB_USER}/" /var/www/html/web/sites/default/settings.local.php
  sed -i "s/dbpassword/${DB_PASSWORD}/" /var/www/html/web/sites/default/settings.local.php
  sed -i "s/dbhost/${DB_HOST}/" /var/www/html/web/sites/default/settings.local.php
  sed -i "s/dbport/${DB_PORT}/" /var/www/html/web/sites/default/settings.local.php

  echo "settings.local.php configured"

fi

if [ ! -e "/etc/msmtprc" ]; then

  export ACCOUNT_NAME=${ACCOUNT_NAME}
  export SMTP_SERVER=${SMTP_SERVER}
  export SMTP_PORT=${SMTP_PORT}
  export SMTP_USERNAME=${SMTP_USERNAME}
  export SMTP_PASSWORD=${SMTP_PASSWORD}
  export SMTP_EMAIL=${SMTP_EMAIL}

  touch /etc/msmtprc
  chmod 0600 /etc/msmtprc
  chown www-data:www-data /etc/msmtprc

  echo "defaults" >> /etc/msmtprc
  echo "logfile /var/log/msmtp.log" >> /etc/msmtprc

  echo "tls on" >> /etc/msmtprc
  echo "tls_starttls on" >> /etc/msmtprc
  echo "tls_trust_file /etc/ssl/certs/ca-certificates.crt" >> /etc/msmtprc

  echo "from ${SMTP_EMAIL}" >> /etc/msmtprc
  echo "host ${SMTP_SERVER}" >> /etc/msmtprc
  echo "port ${SMTP_PORT}" >> /etc/msmtprc

  echo "auth login" >> /etc/msmtprc
  echo "user ${SMTP_USERNAME}" >> /etc/msmtprc
  echo "password ${SMTP_PASSWORD}" >> /etc/msmtprc

  echo "account ${ACCOUNT_NAME}" >> /etc/msmtprc
  echo "account default : ${ACCOUNT_NAME}" >> /etc/msmtprc
  echo "sendmail_path = "/usr/local/bin/msmtp -C /etc/msmtprc -a ${ACCOUNT_NAME} -t"" >> /usr/local/etc/php/conf.d/mail.ini

  echo "msmtprc and php configured for email"

else
  echo "MSMTP initialization is already finished"
fi

exec "$@"