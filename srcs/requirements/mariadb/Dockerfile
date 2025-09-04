FROM alpine:3.21.4

# Install MariaDB and required tools
RUN apk update && apk add --no-cache mariadb mariadb-client bash

# Copy the setup script
COPY tools/config.sh /config.sh
RUN chmod +x /config.sh

# Create the data directory
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# Expose default MariaDB port
EXPOSE 3306

# Run the setup script as entrypoint
ENTRYPOINT ["/config.sh"]
