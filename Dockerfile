FROM centos
MAINTAINER futabooo <mail@futabooo.com>
RUN yum install -y httpd
ADD index.html /var/www/html/
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

