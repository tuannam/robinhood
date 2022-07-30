FROM debian:buster-slim
RUN apt update -y && apt-get install vim git net-tools nginx jq curl fcgiwrap php-fpm php-mysql -y
RUN rm /etc/nginx/sites-enabled/default
CMD /etc/init.d/php7.3-fpm start && /etc/init.d/fcgiwrap start && /etc/init.d/nginx restart && tail -f /dev/null