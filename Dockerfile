FROM wordpress:latest

# Build-time arguments
ARG MYSQL_PASSWORD
ARG MYSQL_HOST
ARG MYSQL_PORT
ARG MYSQL_DATABASE
ARG MYSQL_USERNAME
ARG MYSQL_ROOT_PASSWORD

# Runtime environment variables
ENV WORDPRESS_DB_HOST=$MYSQL_HOST:$MYSQL_PORT
ENV WORDPRESS_DB_NAME=$MYSQL_DATABASE
ENV WORDPRESS_DB_USER=$MYSQL_USERNAME
ENV WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD
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