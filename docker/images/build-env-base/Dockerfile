# syntax=docker/dockerfile:1
ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/everest/everest-ci/run-env-base:${BASE_IMAGE_TAG}

RUN apt update \
    && apt install --no-install-recommends -y \
    # basic command line tools
    git=1:2.39.2-1.1 \
    curl=7.88.1-10+deb12u5 \
    rsync=3.2.7-1 \
    # build tools
    ninja-build=1.11.1-1 \
    make=4.3-4.1 \
    cmake=3.25.1-1 \
    # compilers
    binutils=2.40-2 \
    gcc=4:12.2.0-3 \
    g++=4:12.2.0-3 \
    # compiler tools
    ccache=4.8+really4.7.5-1 \
    lcov=1.16-1 \
    clang-format-15=1:15.0.6-4+b1 \
    clang-tidy-15=1:15.0.6-4+b1

# Create symlinks for clang-format and clang-tidy
RUN ln -s /usr/bin/clang-format-15 /usr/bin/clang-format \
    && ln -s /usr/bin/clang-tidy-15 /usr/bin/clang-tidy

COPY run-clang-format.py /usr/bin/run-clang-format

# additional packages
RUN apt update \
    && apt install --no-install-recommends -y \
    # required by some everest libraries
    libboost-all-dev=1.74.0.3 \
    # required by libocpp
    libsqlite3-dev=3.40.1-2 \
    libssl-dev=3.0.13-1~deb12u1 \
    # required by everest-framework
    libnode-dev=18.19.0+dfsg-6~deb12u2 \
    # required by packet sniffer module
    pkg-config=1.8.1-1 \
    libpcap-dev=1.10.3-1 \
    libcap-dev=1:2.66-4

# Install Python packages
RUN apt update \
    && apt install --no-install-recommends -y \
    python3-venv=3.11.2-1+b1 \
    python3-pydantic=1.10.4-1 \
    python3-psutil=5.9.4-1+b1 \
    python3-cryptography=38.0.4-3 \
    python3-netifaces=0.11.0-2+b1 \
    python3-dateutil=2.8.2-2

RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

# Install additional Python packages
RUN python3 -m pip install --break-system-packages \
    environs==11.0.0 \
    aiofile==3.8.8 \
    py4j==0.10.9.7 \
    gcovr==7.2

# Install EVerest dependency manager
ARG EDM_VERSION=v0.6.2
RUN python3 -m pip install --break-system-packages \
    git+https://github.com/EVerest/everest-dev-environment@${EDM_VERSION}#subdirectory=dependency_manager

# Install everest-cmake
ARG EVEREST_CMAKE_PATH=/usr/lib/cmake/everest-cmake
ARG EVEREST_CMAKE_VERSION=v0.4.3
RUN git clone https://github.com/EVerest/everest-cmake.git ${EVEREST_CMAKE_PATH} \
    && cd ${EVEREST_CMAKE_PATH} \
    && git checkout ${EVEREST_CMAKE_VERSION} \
    && rm -r .git
