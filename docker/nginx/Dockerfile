FROM nginx:alpine

COPY nginx.conf /etc/nginx/

ARG PHP_UPSTREAMS
RUN for stream in ${PHP_UPSTREAMS}; do \
    echo "upstream ${stream} { server ${stream}:9000; }" > /etc/nginx/conf.d/${stream}.conf; \
    done;

COPY ./default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 81 443