FROM php:7.4-cli

MAINTAINER oayanda oayanda@oayanda.com

# Application working directory
WORKDIR /todo

# Install required PHP dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    zlib1g-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    zip \
    curl \
    unzip \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-source delete

# Downlod composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN COMPOSER_ALLOW_SUPERUSER=1

# Copy all files from the source directory to destination (WORKDIR/todo)
COPY . .

# Composer install all dependencies required for the application
RUN composer install 

# Open this port
EXPOSE 8000

ENTRYPOINT [ "bash", "app.sh" ]
