# مرحله اول: استفاده از PHP 8.2 CLI
FROM php:8.2-cli

# تنظیم دایرکتوری کاری
WORKDIR /var/www

# نصب پکیج‌های لازم سیستم
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev mysql-client \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# نصب Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# فقط فایل‌های composer رو اول کپی کن برای کش بهتر
COPY composer.json composer.lock* ./

# نصب پکیج‌های PHP از طریق Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# حالا باقی فایل‌ها رو کپی کن
COPY . .

# تنظیم مجوز برای فولدرهای مورد نیاز
RUN chown -R www-data:www-data storage bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache

# اجرای دستورهای Artisan مهم بعد از نصب
RUN php artisan key:generate && \
    php artisan migrate --force && \
    php artisan storage:link && \
    php artisan config:cache

# باز کردن پورت برای سرور Laravel
EXPOSE 8000

# اجرای سرور لاراول
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
