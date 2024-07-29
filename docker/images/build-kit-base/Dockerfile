# syntax=docker/dockerfile:1
ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/everest/everest-ci/build-env-base:${BASE_IMAGE_TAG}

ENV WORKSPACE_PATH=/workspace
ARG EXT_MOUNT=/ext
ENV EXT_MOUNT=$EXT_MOUNT

COPY ./entrypoint.sh /

# Disable ownership checks
RUN git config --global --add safe.directory '*'

WORKDIR $WORKSPACE_PATH

ENTRYPOINT ["/entrypoint.sh"]
CMD ["run-script", "init"]
