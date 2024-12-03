FROM wordpress:6.7.0-php8.1-apache

# Build-time arguments
ARG MARIADB_PASSWORD
ARG MARIADB_HOST
ARG MARIADB_PORT
ARG MARIADB_DATABASE
ARG MARIADB_USERNAME
ARG MARIADB_ROOT_PASSWORD

# Runtime environment variables
ENV WORDPRESS_DB_HOST=$MARIADB_HOST:$MARIADB_PORT
ENV WORDPRESS_DB_NAME=$MARIADB_DATABASE
ENV WORDPRESS_DB_USER=$MARIADB_USERNAME
ENV WORDPRESS_DB_PASSWORD=$MARIADB_PASSWORD
ENV WORDPRESS_TABLE_PREFIX="RW_"
ENV PORT=80

# Configure Apache
RUN echo "ServerName 0.0.0.0" >> /etc/apache2/apache2.conf
RUN echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf

# Update Apache ports configuration to use PORT environment variable
RUN sed -i 's/Listen 80/Listen ${PORT}/g' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/g' /etc/apache2/sites-available/000-default.conf

# Expose the port that will be used
EXPOSE ${PORT}

# Start Apache in foreground
CMD ["apache2-foreground"]