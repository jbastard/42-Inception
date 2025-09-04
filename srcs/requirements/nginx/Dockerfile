FROM alpine:3.21.4

RUN apk update && apk add nginx openssl

RUN mkdir -p /etc/nginx/ssl /run/nginx

# Generate a self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/ST=Paris/L=Paris/O=42/CN=localhost" -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt

COPY tools/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
