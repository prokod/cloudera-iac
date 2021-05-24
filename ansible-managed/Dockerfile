FROM centos:7.9.2009 AS ansiblemanagedgeneric

USER root
# Without this COPY ... $HOME/...  will not work
ENV HOME /root

# Local relative path of image dependencies to copy to image from.
ARG DEPENDENCIES_DIR
# App root dir under /opt that application executables and resources will reside in. Will be created in the image dir structure
ARG BUILD_DIR

ARG PROXY_USER

ARG PROXY_PASS

ARG CONDA_ENV_NAME

ARG VERSION

ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
find /lib/systemd/system/multi-user.target.wants/ \( -type l -o -type f \) -not -name 'systemd-user-sessions.service' -delete;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

# Generate ssh key for user ansible
RUN yum -y install openssh openssh-server git net-tools iputils sudo
RUN systemctl enable sshd.service
# Red Hat 7.x ssh fails with error "System is booting up. See pam_nologin(8) \ Authentication Failed." (but system is booted)
RUN systemctl enable systemd-user-sessions.service

# Copy ansible user public key
COPY ${DEPENDENCIES_DIR}/id_rsa.pub /tmp/
# Prepare and bootstrap Ansible
COPY ${DEPENDENCIES_DIR}/bootstrap_ansible.sh $HOME/.local/bin/
RUN chmod a+x $HOME/.local/bin/bootstrap_ansible.sh
WORKDIR $HOME
RUN $HOME/.local/bin/bootstrap_ansible.sh

RUN /usr/bin/ssh-keygen -A

CMD ["/usr/sbin/init"]
