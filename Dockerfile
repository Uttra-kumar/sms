FROM php:8.2-cli

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_pgsql

# Composer install
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy code
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel optimize
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# Start command
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]
EXPOSE 10000
