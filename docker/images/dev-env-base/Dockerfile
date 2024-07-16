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

# Additional Build Tools
# Additional Build Tool - Documentation
RUN apt update && apt install --no-install-recommends -y \
    python3-sphinx=5.3.0-4
RUN python3 -m pip install --break-system-packages \
    # Sphinx extensions
    sphinxcontrib-contentui==0.2.5 \
    sphinxcontrib-svg2pdfconverter==1.2.2

# Development Tools
# Development Tools - General
RUN apt update \
    && apt install --no-install-recommends -y \
    wget=1.21.3-1+b2 \
    doxygen=1.9.4-4 \
    graphviz=2.42.2-7+b3 \
    build-essential=12.9 \
    cppcheck=2.10-2 \
    bash-completion=1:2.11-6
# Development Tools - Documentation
RUN python3 -m pip install --break-system-packages \
    # language server RST/Sphinx
    esbonio==0.16.4 \
    # Style checker for RST/Sphinx
    doc8==1.1.1

RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

USER ${USERNAME}

RUN mkdir ~/.ssh \
    && ssh-keyscan github.com > ~/.ssh/known_hosts

ENV PATH="/home/$USERNAME/.local/bin:$PATH"
ENV CPM_SOURCE_CACHE="/home/$USERNAME/.cache/CPM"
