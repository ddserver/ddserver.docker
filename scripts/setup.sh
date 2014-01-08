#! /bin/sh

# Create the ddserver database
mysql -e "CREATE DATABASE ddserver"

# Populate the database with the schema
mysql ddserver < /src/ddserver/ddserver/resources/doc/schema.sql

# Create a ddserver user and allow access to the database
mysql -e "GRANT USAGE ON *.* to ddserver@localhost IDENTIFIED BY 'ddserver-passwd'"
mysql -e "GRANT ALL PRIVILEGES ON ddserver.* to ddserver@localhost"
