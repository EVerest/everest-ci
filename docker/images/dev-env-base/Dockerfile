# syntax=docker/dockerfile:1
ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/everest/everest-ci/build-env-base:${BASE_IMAGE_TAG}

ARG USERNAME=docker
ARG USER_UID=1000
RUN useradd -ms /bin/bash -u ${USER_UID} -U ${USERNAME}
# Extend the timeout
RUN mkdir -p /etc/apt/apt.conf.d/ \
    && echo 'Acquire::http::Timeout "100";' >> /etc/apt/apt.conf.d/99stahp_stahping \
    && echo 'Acquire::ftp::Timeout "100";' >> /etc/apt/apt.conf.d/99stahp_stahping \
    && echo 'Acquire::Retries "10";' >> /etc/apt/apt.conf.d/99stahp_stahping
RUN apt update \
    && apt install --no-install-recommends -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Development Tools
# Development Tools - General
RUN apt update \
    && apt install --no-install-recommends -y \
    wget \
    doxygen \
    graphviz \
    build-essential \
    cppcheck \
    bash-completion \
    vim \
    # Development Tools - Debugging
    gdb \
    nmap

# Development Tools - Documentation
RUN python3 -m pip install --break-system-packages \
    # language server RST/Sphinx
    esbonio \
    # Style checker for RST/Sphinx
    doc8

# Development Tools - Docker
RUN apt update \
    && apt install --no-install-recommends -y \
    ca-certificates \
    curl \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update \
    && apt install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin


RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

USER ${USERNAME}

RUN mkdir ~/.ssh \
    && ssh-keyscan github.com > ~/.ssh/known_hosts

ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# Create cache directory for cpm to avoid permission issues
RUN mkdir -p ${HOME}/.cache/cpm

COPY ../../../applications/utils/scripts/package_version_logger.py /usr/local/bin/package_version_logger.py
RUN package_version_logger.py --output-file /package_inventory.json

COPY entrypoint.sh /entrypoint.sh
ARG TARGETARCH
COPY entrypoint_wrapper.sh /entrypoint_wrapper.sh
RUN if [ ${TARGETARCH} != "amd64" ]; then \
        mv /entrypoint.sh /wrapped_entrypoint.sh; \
        cp /entrypoint_wrapper.sh /entrypoint.sh; \
    fi; \
    sudo rm /entrypoint_wrapper.sh
ENTRYPOINT [ "/entrypoint.sh" ]
