FROM php:8.2-apache

# نصب پکیج‌های لازم
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libzip-dev \
    mysql-client \
    libpq-dev

# نصب اکستنشن‌های PHP
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# فعال‌سازی mod_rewrite در Apache
RUN a2enmod rewrite

# تنظیم پوشه اصلی پروژه
WORKDIR /var/www/html

# کپی فایل‌های پروژه
COPY . .

# نصب Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# دسترسی‌ها
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

EXPOSE 80
