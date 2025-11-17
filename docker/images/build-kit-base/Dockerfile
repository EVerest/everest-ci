# syntax=docker/dockerfile:1
ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/everest/everest-ci/build-env-base:${BASE_IMAGE_TAG}

ENV WORKSPACE_PATH=/workspace
ARG EXT_MOUNT=/ext
ENV EXT_MOUNT=$EXT_MOUNT

# Disable ownership checks
RUN git config --global --add safe.directory '*'

WORKDIR $WORKSPACE_PATH

COPY entrypoint.sh /entrypoint.sh
ARG TARGETARCH
COPY entrypoint_wrapper.sh /entrypoint_wrapper.sh
RUN if [ ${TARGETARCH} != "amd64" ]; then \
        mv /entrypoint.sh /wrapped_entrypoint.sh; \
        cp /entrypoint_wrapper.sh /entrypoint.sh; \
    fi; \
    rm /entrypoint_wrapper.sh
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["run-script", "init"]
