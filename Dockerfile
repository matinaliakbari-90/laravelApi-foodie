FROM php:8.1-apache

# نصب افزونه‌های لازم برای Laravel
RUN apt-get update && apt-get install -y \
    git unzip zip curl libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl

# نصب Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# کپی کردن سورس پروژه
COPY . /var/www/html

WORKDIR /var/www/html

# نصب پکیج‌های composer
RUN composer install --no-dev --optimize-autoloader

# تنظیمات فایل‌ها
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
