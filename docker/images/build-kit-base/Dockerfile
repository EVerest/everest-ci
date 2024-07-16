# syntax=docker/dockerfile:1
ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/everest/everest-ci/build-env-base:${BASE_IMAGE_TAG}

ENV WORKSPACE_PATH=/workspace
ENV ASSETS_PATH=/assets
ARG EXT_MOUNT=/ext
ENV EXT_MOUNT=$EXT_MOUNT

RUN mkdir $ASSETS_PATH
COPY maven-settings.xml $ASSETS_PATH/

COPY ./entrypoint.sh /

# Disable ownership checks
RUN git config --global --add safe.directory '*'

WORKDIR $WORKSPACE_PATH

ENTRYPOINT ["/entrypoint.sh"]
CMD ["run-script", "init"]
