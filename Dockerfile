FROM base/arch

# Do a system update
RUN pacman -Syu --noconfirm

# Install python and required python libraries
# TODO: missing native packages: enum, recaptcha-client
RUN pacman -S --noconfirm python2 python2-setuptools python2-beaker python2-bottle python2-jinja python2-formencode python2-passlib 

# Install mysql server and python binding
RUN pacman -S --noconfirm mariadb mysql-python

# Install powerdns
RUN pacman -S --noconfirm pdns

# Install the supervisor
RUN pacman -S --noconfirm supervisor

# Add the ddserver source and install it
ADD ddserver /src/ddserver
RUN cd /src/ddserver; python2 setup.py install

# Add the script folder and copy configs to various places
ADD scripts /src/scripts

ADD configs/supervisord.conf         /etc/supervisord.conf
ADD configs/supervisor.mysql.conf    /etc/supervisor.d/
ADD configs/supervisor.pdns.conf     /etc/supervisor.d/
ADD configs/supervisor.ddserver.conf /etc/supervisor.d/

ADD configs/pdns.conf /etc/powerdns/pdns.conf

ADD configs/my.cnf /etc/mysql/my.cnf

ADD configs/ddserver.conf /etc/ddserver/ddserver.conf

# Run the setup scripts
RUN /src/scripts/mysql_wrap /src/scripts/setup.sh

# Expose ddserver, mysql and dns ports
EXPOSE  80 3306 53 53/udp

# Run the supervisor to start all services
CMD ["/usr/bin/supervisord"]

