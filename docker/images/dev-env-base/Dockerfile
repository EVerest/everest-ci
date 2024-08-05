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
    wget=1.21.3-1+b2 \
    doxygen=1.9.4-4 \
    graphviz=2.42.2-7+b3 \
    build-essential=12.9 \
    cppcheck=2.10-2 \
    bash-completion=1:2.11-6 \
    vim=2:9.0.1378-2 \
    # Development Tools - Debugging
    gdb=13.1-3 \
    nmap=7.93+dfsg1-1
# Development Tools - Documentation
RUN python3 -m pip install --break-system-packages \
    # language server RST/Sphinx
    esbonio==0.16.4 \
    # Style checker for RST/Sphinx
    doc8==1.1.1
# Development Tools - Docker
RUN sudo apt update && sudo apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    && sudo install -m 0755 -d /etc/apt/keyrings \
    && sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && sudo chmod a+r /etc/apt/keyrings/docker.asc \
    && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && sudo apt update \
    && sudo apt install -y --no-install-recommends \
    docker-ce=5:27.0.3-1~debian.12~bookworm \
    docker-ce-cli=5:27.1.1-1~debian.12~bookworm \
    containerd.io=1.7.19-1 \
    docker-buildx-plugin=0.16.1-1~debian.12~bookworm \
    docker-compose-plugin=2.29.1-1~debian.12~bookworm

RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

USER ${USERNAME}

RUN mkdir ~/.ssh \
    && ssh-keyscan github.com > ~/.ssh/known_hosts

ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# Create cache directory for cpm to avoid permission issues
RUN mkdir -p ${HOME}/.cache/cpm
