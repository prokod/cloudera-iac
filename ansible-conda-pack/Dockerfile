FROM continuumio/miniconda3:4.9.2

USER root
# Local relative path of image dependencies to copy to image from.
ARG DEPENDENCIES_DIR
# App root dir under /opt that application executables and resources will reside in. Will be created in the image dir structure
ARG BUILD_DIR

ARG PROXY_USER

ARG PROXY_PASS

ARG CONDA_ENV_NAME

ARG VERSION

RUN mkdir -p ${BUILD_DIR}
WORKDIR ${BUILD_DIR}

COPY ${DEPENDENCIES_DIR}/condarc.yml /opt/conda/.condarc

RUN conda config --show
RUN conda config --show-sources
RUN conda install -c defaults conda-pack=0.6

COPY ${DEPENDENCIES_DIR}/environment.yml ./

RUN mkdir -p $BUILD_DIR/out

VOLUME $BUILD_DIR/out

# Prepare to start service
COPY ${DEPENDENCIES_DIR}/dopack.sh ./
RUN chmod a+x ${BUILD_DIR}/dopack.sh

ENV IMG_VERSION 0

ENTRYPOINT ["/bin/bash", "./dopack.sh"]