# 1. Use PHP 8.2 with FPM
FROM php:8.2-fpm

# 2. Set working directory inside the container
WORKDIR /var/www

# 3. Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    zip unzip curl git \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# 4. Install Composer (PHP dependency manager)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Copy Laravel project files into container
COPY . .

# 6. Install Laravel PHP dependencies
RUN composer install

# 7. Permissions (for storage and cache)
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage

# 8. Start Laravel development server
CMD php artisan serve --host=0.0.0.0 --port=8000
