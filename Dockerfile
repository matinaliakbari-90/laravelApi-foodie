# Dockerfile

FROM laravelsail/php82-composer

WORKDIR /var/www/html

COPY . .

RUN apt-get update \
    && apt-get install -y unzip zip git curl libzip-dev libpng-dev \
    && docker-php-ext-install pdo_mysql zip gd

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
