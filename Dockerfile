FROM centos
MAINTAINER futabooo <mail@futabooo.com>

RUN yum update -y

# Install SSH
RUN yum install -y --enablerepo=centosplus sudo passwd openssh-server openssh-clients
# Install PHP,MySQL
RUN yum install -y --enablerepo=centosplus httpd php php-mbstring mysql-server mysql mysql-devel php-mysql
# Install easy_install
RUN yum install -y python-setuptools

# Create sshkey
RUN /usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''
RUN /usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# Create User
RUN useradd worker
RUN passwd -f -u worker
RUN mkdir -p /home/worker/.ssh
RUN chmod 700 /home/worker/.ssh
ADD ./authorized_keys /home/worker/.ssh/authorized_keys
RUN chmod 600 /home/worker/.ssh/authorized_keys
RUN chown -R worker /home/worker/

# Add sudoers
RUN echo "worker  ALL=(ALL)  ALL" >> /etc/sudoers.d/worker

# Create supervisord
RUN easy_install supervisor
RUN mkdir -p /var/log/supervisor
ADD ./supervisord.conf /etc/supervisord.conf

# Add WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# wordpress用のmysql設定
# 1行で書かないとerrorになる
RUN service mysqld start && mysqladmin -u root password password && mysql -u root -ppassword -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8; grant all privileges on wordpress.* to wordpress@localhost identified by 'wordpress';" && cd /var/www/html && wp core download --locale=ja && wp core config --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=localhost --locale=ja && wp core install --url=http://example.com --title=example --admin_name=example --admin_email=example@example.com --admin_password=password

CMD ["/usr/bin/supervisord"]
