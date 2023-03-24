ARG FLUTTER_VERSION="latest"
ARG NGINX_VERSION="alpine"

FROM cirrusci/flutter:${FLUTTER_VERSION} as ui_build

WORKDIR /app

COPY . .

RUN flutter pub get && \
    flutter build web

FROM nginx:${NGINX_VERSION} AS ui_run

COPY .docker/nginx.conf /etc/nginx/conf.d/default.conf

COPY .docker/docker-entrypoint.sh /docker-entrypoint.sh

COPY --from=ui_build /app/build/web /usr/share/nginx/html

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "nginx", "-g","daemon off;" ]
