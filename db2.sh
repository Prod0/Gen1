#! /bin/sh

sudo apt-get update
sudo apt install mysql-server -y
sudo su

rm /etc/mysql/mysql.conf.d/mysqld.cnf
echo "#
# The MySQL database server configuration file.
#
# One can use all long options that the program supports.
# Run program with --help to get a list of available options and with
# --print-defaults to see which it would actually understand and use.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

# Here is entries for some specific programs
# The following values assume you have at least 32M ram

[mysqld]
#
# * Basic Settings
#
user= mysql
# pid-file= /var/run/mysqld/mysqld.pid
# socket= /var/run/mysqld/mysqld.sock
# port= 3306
# datadir= /var/lib/mysql


# If MySQL is running as a replication slave, this should be
# changed. Ref https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_tmpdir
# tmpdir= /tmp
#
# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
bind-address= 0.0.0.0
mysqlx-bind-address= 127.0.0.1
#
# * Fine Tuning
#
key_buffer_size= 16M
# max_allowed_packet= 64M
# thread_stack= 256K

# thread_cache_size       = -1

# This replaces the startup script and checks MyISAM tables if needed
# the first time they are touched
myisam-recover-options  = BACKUP

# max_connections        = 151

# table_open_cache       = 4000

#
# * Logging and Replication
#
# Both location gets rotated by the cronjob.
#
# Log all queries
# Be aware that this log type is a performance killer.
# general_log_file        = /var/log/mysql/query.log
# general_log             = 1
#
# Error log - should be very few entries.
#
# log_error = /var/log/mysql/error.log
#
# Here you can see queries with especially long duration
# slow_query_log= 1
# slow_query_log_file= /var/log/mysql/mysql-slow.log
# long_query_time = 2
# log-queries-not-using-indexes
#
# The following can be used as easy to replay backup logs or for replication.
# note: if you are setting up a replication slave, see README.Debian about
#       other settings you may need to change.
server-id= 2
# binlog_expire_logs_seconds= 2592000
# binlog_do_db= include_database_name
replicate-ignore-db = mysql

# Auto increment offset
auto-increment-increment = 2

# Do not replicate sql queries for the local server ID
replicate-same-server-id = 0

# Beginne automatisch inkrementelle Werte mit 1
auto-increment-offset = 2" > /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart

sudo mysql -e "CREATE USER 'repli'@'%' IDENTIFIED WITH mysql_native_password BY 'Caradhras2022'"
sudo mysql -e "GRANT REPLICATION SLAVE ON *.* TO 'repli'@'%'"
sudo mysql -e "FLUSH PRIVILEGES"

#####

sudo mysql -e "CREATE DATABASE nlpf"
sudo mysql -e "USE nlpf;CREATE TABLE IF NOT EXISTS immobilier (id_mutation VARCHAR(200), date_mutation DATE, valeur_fonciere NUMERIC, adresse_numero NUMERIC, adresse_nom_voie VARCHAR(100), code_postal NUMERIC, nom_commune VARCHAR(100), type_local VARCHAR(50), surface_reelle_bati NUMERIC, nombre_pieces_principales NUMERIC, longitude NUMERIC, latitude NUMERIC)"

sudo mysql -e "ALTER USER 'repli' IDENTIFIED WITH mysql_native_password BY 'Caradhras2022'"
sudo mysql -e "FLUSH PRIVILEGES"
sudo mysql -e "grant all on nlpf.* to 'repli'@'%'"
sudo mysql -e "FLUSH PRIVILEGES"

#####

sudo mysql -e "stop slave"
sudo mysql -e "reset slave"
sudo mysql -e "reset master"

sudo mysql -e "CHANGE MASTER TO MASTER_HOST='10.0.0.100', MASTER_USER='repli', MASTER_PASSWORD='Caradhras2022'"

sudo mysql -e "start slave"

