FROM php:8.1-cli

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates curl

RUN curl -fsSL https://packages.sury.org/php/apt.gpg | tee /etc/apt/trusted.gpg.d/php.gpg

RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libxml2-dev libzip-dev default-mysql-client libonig-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY composer.json composer.lock* ./

RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist || (cat /root/.composer/cache/logs/* || true)

COPY . .

RUN chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache

# پاک‌سازی کش‌ها و اجرای برنامه
EXPOSE 8080

CMD sh -c "php artisan migrate --force && php artisan config:clear && php artisan cache:clear && php artisan config:cache && php artisan serve --host=0.0.0.0 --port=8080"
