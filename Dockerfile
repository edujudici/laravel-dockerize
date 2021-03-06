FROM php:7.2-fpm
LABEL maintainer="edujudici@gmail.com"

ARG USER=eduardo.judici

# Copy composer.lock and composer.json
# COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies and extensions
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        mariadb-client \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        locales \
        zip \
        jpegoptim optipng pngquant gifsicle \
        vim \
        unzip \
        git \
        curl \
        nodejs \
        npm \
        libxml2-dev \
    && docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    && docker-php-ext-install gd pdo_mysql mbstring zip exif pcntl soap \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install composer
RUN echo "Install Composer"
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Add user for laravel application
RUN groupadd -g 1001 ${USER}
RUN useradd -u 1001 -ms /bin/bash -g ${USER} ${USER}

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=${USER}:${USER} . /var/www

# Change current user to ${USER}
USER ${USER}

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
