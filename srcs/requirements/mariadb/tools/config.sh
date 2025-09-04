#!/bin/sh

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql
rm -f /run/mysqld/mysqld.sock

# Initialize MariaDB if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# Start MariaDB in background without networking
mysqld --user=mysql --skip-networking &
pid="$!"

# Wait for it to be ready
until mysqladmin ping --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 1
done

# Create DB and user
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MDB_NAME}\`;
CREATE USER IF NOT EXISTS '${MDB_USER}'@'%' IDENTIFIED BY '${MDB_PWD}';
CREATE USER IF NOT EXISTS '${MDB_USER}'@'localhost' IDENTIFIED BY '${MDB_PWD}';
GRANT ALL PRIVILEGES ON \`${MDB_NAME}\`.* TO '${MDB_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${MDB_NAME}\`.* TO '${MDB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF


mysqladmin -u root shutdown || kill "$pid"

echo "[INFO] Starting final mysqld process..."
exec mysqld --user=mysql --bind-address=0.0.0.0 --port=3306 --skip-networking=0

