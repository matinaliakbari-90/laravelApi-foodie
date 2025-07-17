FROM php:8.1-cli

WORKDIR /var/www/html

# نصب پیش‌نیازها
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    curl \
    git \
    zip \
    unzip \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    default-mysql-client \
    libonig-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# نصب اکستنشن‌های PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# اضافه کردن composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# کپی فایل‌های کامپوزر
COPY composer.json composer.lock* ./

# نصب پکیج‌های PHP
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist || true

# کپی بقیه پروژه
COPY . .

# ساخت symlink برای پوشه storage
RUN php artisan storage:link

# تنظیم permission برای فولدرهای موردنیاز لاراول
RUN chown -R www-data:www-data storage bootstrap/cache public/storage && chmod -R 775 storage bootstrap/cache public/storage

# باز کردن پورت
EXPOSE 8000

# اجرای migration و اجرای پروژه
CMD sh -c "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"
