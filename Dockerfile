# Using bitnami/wordpress base image
FROM bitnami/wordpress:latest

# Installing curl
USER root
RUN apt-get update && apt-get install -y curl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Switch back to the non-root user provided by the Bitnami WordPress image
USER 1001

# Verify Composer installation
RUN composer

#Setting up the Working Directory
WORKDIR /opt/bitnami/wordpress

# Copy the composer.json to the container
COPY composer.json /opt/bitnami/wordpress/composer.json

#Downloading and installing the plugin dependencies
RUN composer install

# Copy the entrypoint.sh script to the container
COPY entrypoint.sh /opt/bitnami/scripts/wordpress/entrypoint.sh

# Switch to root user
USER root

# Making entrypoint.sh executable
RUN chmod +x /opt/bitnami/scripts/wordpress/entrypoint.sh

# Switch back to the non-root user provided by the Bitnami WordPress image
USER 1001
