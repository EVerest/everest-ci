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

# renovate: datasource=repology depName=debian_13/wget versioning=loose
ENV WGET_VERSION=1.25.0-2
# renovate: datasource=repology depName=debian_13/doxygen versioning=loose
ENV DOXYGEN_VERSION=1.9.8+ds-2.1
# renovate: datasource=repology depName=debian_13/graphviz versioning=loose
ENV GRAPHVIZ_VERSION=2.42.4-3
# renovate: datasource=repology depName=debian_13/build-essential-mipsen versioning=loose
ENV BUILD_ESSENTIAL_VERSION=12.12
# renovate: datasource=repology depName=debian_13/cppcheck versioning=loose
ENV CPPCHECK_VERSION=2.17.1-2
# renovate: datasource=repology depName=debian_13/bash-completion versioning=loose
ENV BASH_COMPLETION_VERSION=1:2.16.0-7
# renovate: datasource=repology depName=debian_13/vim versioning=loose
ENV VIM_VERSION=2:9.1.1230-2
# renovate: datasource=repology depName=debian_13/gdb versioning=loose
ENV GDB_VERSION=16.3-1
# renovate: datasource=repology depName=debian_13/nmap versioning=loose
ENV NMAP_VERSION=7.95+dfsg-3

# Development Tools
# Development Tools - General
RUN apt update \
    && apt install --no-install-recommends -y \
    wget=${WGET_VERSION} \
    doxygen=${DOXYGEN_VERSION} \
    graphviz=${GRAPHVIZ_VERSION} \
    build-essential=${BUILD_ESSENTIAL_VERSION} \
    cppcheck=${CPPCHECK_VERSION} \
    bash-completion=${BASH_COMPLETION_VERSION} \
    vim=${VIM_VERSION} \
    # Development Tools - Debugging
    gdb=${GDB_VERSION} \
    nmap=${NMAP_VERSION}

# renovate: datasource=pypi depName=esbonio
ENV ESBONIO_VERSION=0.16.5
# renovate: datasource=pypi depName=doc8
ENV DOC8_VERSION=2.0.0

# Development Tools - Documentation
RUN python3 -m pip install --break-system-packages \
    # language server RST/Sphinx
    esbonio==${ESBONIO_VERSION} \
    # Style checker for RST/Sphinx
    doc8==${DOC8_VERSION}

# renovate: datasource=repology depName=debian_13/ca-certificates versioning=loose
ENV CA_CERTIFICATES_VERSION=20250419
# renovate: datasource=repology depName=debian_13/curl versioning=loose
ENV CURL_VERSION=8.14.1-2

# Not managed by renovate, because no available datasource
ENV DOCKER_CE_VERSION=5:28.1.0-1~debian.13~trixie
ENV DOCKER_CE_CLI_VERSION=5:28.1.0-1~debian.13~trixie
ENV CONTAINERD_IO_VERSION=1.7.27-1
ENV DOCKER_BUILDX_PLUGIN_VERSION=0.22.0-1~debian.13~trixie
ENV DOCKER_COMPOSE_PLUGIN_VERSION=2.35.0-1~debian.13~trixie

# Development Tools - Docker
RUN apt update \
    && apt install --no-install-recommends -y \
    ca-certificates=${CA_CERTIFICATES_VERSION} \
    curl=${CURL_VERSION} \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update \
    && apt install -y --no-install-recommends \
    docker-ce=${DOCKER_CE_VERSION} \
    docker-ce-cli=${DOCKER_CE_CLI_VERSION} \
    containerd.io=${CONTAINERD_IO_VERSION} \
    docker-buildx-plugin=${DOCKER_BUILDX_PLUGIN_VERSION} \
    docker-compose-plugin=${DOCKER_COMPOSE_PLUGIN_VERSION}


RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

USER ${USERNAME}

RUN mkdir ~/.ssh \
    && ssh-keyscan github.com > ~/.ssh/known_hosts

ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# Create cache directory for cpm to avoid permission issues
RUN mkdir -p ${HOME}/.cache/cpm

COPY entrypoint.sh /entrypoint.sh
ARG TARGETARCH
COPY entrypoint_wrapper.sh /entrypoint_wrapper.sh
RUN if [ ${TARGETARCH} != "amd64" ]; then \
        mv /entrypoint.sh /wrapped_entrypoint.sh; \
        cp /entrypoint_wrapper.sh /entrypoint.sh; \
    fi; \
    sudo rm /entrypoint_wrapper.sh
ENTRYPOINT [ "/entrypoint.sh" ]
