FROM centos
MAINTAINER futabooo <mail@futabooo.com>

RUN yum update -y

# Install SSH
RUN yum install -y sudo passwd openssh-server openssh-clients

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

#RUN yum install -y httpd
#ADD index.html /var/www/html/
EXPOSE 22

