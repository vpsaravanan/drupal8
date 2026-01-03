# Dockerfile for Drupal 8.9.x with PHP-FPM
FROM php:7.4.33-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    git \
    wget \
    unzip \
    mariadb-client \
    libmagickwand-dev \
    --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && rm -rf /var/lib/apt/lists/*

# Configure GD library
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mysqli \
    gd \
    zip \
    xml \
    mbstring \
    curl \
    opcache \
    bcmath \
    soap \
    exif

# Install Composer
COPY --from=composer:2.1 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Download and extract Drupal 8.9.x
RUN wget https://ftp.drupal.org/files/projects/drupal-8.9.20.tar.gz \
    && tar -xzf drupal-8.9.20.tar.gz --strip-components=1 \
    && rm drupal-8.9.20.tar.gz \
    && rm -rf /var/www/html/sites/default/files

# Create required directories and set permissions
RUN mkdir -p /var/www/html/sites/default/files \
    && mkdir -p /var/www/html/sites/default/private \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copy PHP configuration
# COPY ./docker/php-fpm.conf /usr/local/etc/php-fpm.d/zz-drupal.conf
COPY ./docker/php.ini /usr/local/etc/php/conf.d/custom.ini

# Expose port 9000
EXPOSE 9000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD php-fpm-healthcheck || exit 1

# Start PHP-FPM
CMD ["php-fpm"]