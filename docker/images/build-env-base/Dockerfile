# syntax=docker/dockerfile:1
ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/everest/everest-ci/run-env-base:${BASE_IMAGE_TAG}

RUN apt update \
    && apt install --no-install-recommends -y \
    # basic command line tools
    git \
    curl \
    rsync \
    iproute2 \
    # build tools
    ninja-build \
    make \
    cmake \
    # compilers
    binutils \
    gcc \
    g++ \
    # compiler tools
    ccache \
    lcov \
    clang-format-15 \
    clang-tidy-15 \
    # documentation
    doxygen

# Create symlinks for clang-format and clang-tidy
RUN ln -s /usr/bin/clang-format-15 /usr/bin/clang-format \
    && ln -s /usr/bin/clang-tidy-15 /usr/bin/clang-tidy

COPY run-clang-format.py /usr/bin/run-clang-format

# additional packages
RUN apt update \
    && apt install --no-install-recommends -y \
    # required by some everest libraries
    libboost-all-dev \
    # required by libocpp
    libsqlite3-dev \
    libssl-dev \
    # required by everest-framework
    libnode-dev \
    # required by packet sniffer module
    pkg-config \
    libpcap-dev \
    libcap-dev \
    # Install Python packages
    # Install Python packages - general
    python3-venv \
    # Install Python packages - required by everest-core to run integration tests
    python3-build \
    # Install Python packages- required to build documentation
    python3-sphinx

RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

# Install additional Python packages
RUN python3 -m pip install --break-system-packages \
    gcovr \
    #Required by documentation - Sphinx extensions
    sphinxcontrib-contentui \
    sphinxcontrib-svg2pdfconverter

# Install EVerest dependency manager
RUN python3 -m pip install --break-system-packages \
    git+https://github.com/EVerest/everest-dev-environment#subdirectory=dependency_manager

# Install everest-cmake
ENV EVEREST_CMAKE_PATH=/usr/lib/cmake/everest-cmake
# renovate: datasource=github-releases depName=EVerest/everest-cmake versioning=loose
ENV EVEREST_CMAKE_VERSION=v0.6.0
RUN git clone https://github.com/EVerest/everest-cmake.git ${EVEREST_CMAKE_PATH} \
    && cd ${EVEREST_CMAKE_PATH} \
    && git checkout ${EVEREST_CMAKE_VERSION} \
    && rm -r .git

COPY ../../../applications/utils/scripts/package_version_logger.py /usr/local/bin/package_version_logger.py
RUN package_version_logger.py --output-file /package_inventory.json

COPY entrypoint.sh /entrypoint.sh
ARG TARGETARCH
COPY entrypoint_wrapper.sh /entrypoint_wrapper.sh
RUN if [ ${TARGETARCH} != "amd64" ]; then \
        mv /entrypoint.sh /wrapped_entrypoint.sh; \
        cp /entrypoint_wrapper.sh /entrypoint.sh; \
    fi; \
    rm /entrypoint_wrapper.sh
ENTRYPOINT [ "/entrypoint.sh" ]
