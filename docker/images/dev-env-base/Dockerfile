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

# renovate: datasource=repology depName=debian_12/wget versioning=loose
ENV WGET_VERSION=1.21.3-1+b2
# renovate: datasource=repology depName=debian_12/doxygen versioning=loose
ENV DOXYGEN_VERSION=1.9.4-4
# renovate: datasource=repology depName=debian_12/graphviz versioning=loose
ENV GRAPHVIZ_VERSION=2.42.2-7+deb12u1
# renovate: datasource=repology depName=debian_12/build-essential-mipsen versioning=loose
ENV BUILD_ESSENTIAL_VERSION=12.9
# renovate: datasource=repology depName=debian_12/cppcheck versioning=loose
ENV CPPCHECK_VERSION=2.10-2
# renovate: datasource=repology depName=debian_12/bash-completion versioning=loose
ENV BASH_COMPLETION_VERSION=1:2.11-6
# renovate: datasource=repology depName=debian_12/vim versioning=loose
ENV VIM_VERSION=2:9.0.1378-2
# renovate: datasource=repology depName=debian_12/gdb versioning=loose
ENV GDB_VERSION=13.1-3
# renovate: datasource=repology depName=debian_12/nmap versioning=loose
ENV NMAP_VERSION=7.93+dfsg1-1

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
ENV DOC8_VERSION=1.1.2

# Development Tools - Documentation
RUN python3 -m pip install --break-system-packages \
    # language server RST/Sphinx
    esbonio==${ESBONIO_VERSION} \
    # Style checker for RST/Sphinx
    doc8==${DOC8_VERSION}

# renovate: datasource=repology depName=debian_12/ca-certificates versioning=loose
ENV CA_CERTIFICATES_VERSION=20230311
# renovate: datasource=repology depName=debian_12/curl versioning=loose
ENV CURL_VERSION=7.88.1-10+deb12u8

# Not managed by renovate, because no available datasource
ENV DOCKER_CE_VERSION=5:27.0.3-1~debian.12~bookworm
ENV DOCKER_CE_CLI_VERSION=5:27.1.1-1~debian.12~bookworm
ENV CONTAINERD_IO_VERSION=1.7.19-1
ENV DOCKER_BUILDX_PLUGIN_VERSION=0.16.1-1~debian.12~bookworm
ENV DOCKER_COMPOSE_PLUGIN_VERSION=2.29.1-1~debian.12~bookworm

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
