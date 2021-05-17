FROM registry.access.redhat.com/ubi7/ubi:7.9 AS build

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

RUN mkdir -p $BUILD_DIR/out
VOLUME $BUILD_DIR/out

# Add userr ansible
RUN adduser ansible

# Generate ssh key for user ansible
RUN yum -y install openssh
USER ansible
ENV HOME /home/ansible
COPY --chown=ansible:ansible ${DEPENDENCIES_DIR}/gen_sshkey.sh $HOME/.local/bin/
RUN chmod a+x $HOME/.local/bin/gen_sshkey.sh
WORKDIR $HOME
RUN $HOME/.local/bin/gen_sshkey.sh

RUN mkdir -p $HOME/.conda/packs
RUN mkdir -p $HOME/.conda/ansible
WORKDIR $HOME/.conda

COPY --chown=ansible:ansible ${DEPENDENCIES_DIR}/${CONDA_ENV_NAME}-${VERSION}.tar.gz ./packs

RUN tar -zxf ./packs/${CONDA_ENV_NAME}-${VERSION}.tar.gz -C ansible

RUN mkdir -p $HOME/.local/bin
COPY --chown=ansible:ansible ${DEPENDENCIES_DIR}/dounpack.sh $HOME/.local/bin/
RUN chmod a+x $HOME/.local/bin/dounpack.sh

RUN echo 'source $HOME/.local/bin/dounpack.sh' > ~/.bashrc
