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

# Generate ssh key for user ansible
RUN yum -y install openssh openssh-server git net-tools iputils

# Copy ansible user public key
COPY ${DEPENDENCIES_DIR}/id_rsa.pub /tmp/
# Prepare and bootstrap Ansible
COPY ${DEPENDENCIES_DIR}/bootstrap_ansible.sh $HOME/.local/bin/
RUN chmod a+x $HOME/.local/bin/bootstrap_ansible.sh
WORKDIR $HOME
RUN $HOME/.local/bin/bootstrap_ansible.sh

# USER ansible
# ENV HOME /home/ansible
# WORKDIR $HOME

RUN /usr/bin/ssh-keygen -A
ENTRYPOINT ["/usr/sbin/sshd", "-D"]

