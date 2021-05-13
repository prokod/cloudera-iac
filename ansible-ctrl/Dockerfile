FROM registry.access.redhat.com/ubi7/ubi:7.9

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

RUN mkdir -p /opt/conda/packs

RUN mkdir -p /opt/conda/ansible

WORKDIR /opt/conda

COPY ${DEPENDENCIES_DIR}/${CONDA_ENV_NAME}-${VERSION}.tar.gz /opt/conda/packs

RUN tar -zxf /opt/conda/packs/${CONDA_ENV_NAME}-${VERSION}.tar.gz -C ansible

RUN mkdir -p $HOME/.local/bin
COPY ${DEPENDENCIES_DIR}/dounpack.sh $HOME/.local/bin/
RUN chmod a+x $HOME/.local/bin/dounpack.sh

RUN echo 'source $HOME/.local/bin/dounpack.sh' > ~/.bashrc
