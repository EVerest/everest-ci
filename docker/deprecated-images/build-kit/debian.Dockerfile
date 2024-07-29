# syntax=docker/dockerfile:1
FROM debian:11.7-slim

ARG EXT_MOUNT=/ext
ARG EVEREST_CMAKE_PATH=/usr/lib/cmake/everest-cmake

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        # basic command line tools
        git \
        curl \
        rsync \
        # build tools
        ninja-build \
        make \
        cmake \
        # compilers
        binutils \
        gcc \
        g++ \
        # common dev libraries
        #linux-headers \
        # compiler tools
        clang-tidy-13 \
        ccache \
        # python3 support
        python3-pip \
        # required for testing
        libgtest-dev \
        lcov

# additional packages
RUN apt-get install --no-install-recommends -y \
        # required by some everest libraries
        libboost-all-dev \
        # required by libocpp
        libsqlite3-dev \
        libssl-dev \
        # required by everest-framework
        nodejs \
        libnode-dev \
        npm \
        # required by packet sniffer module
        pkg-config \
        libpcap-dev \
        # required by RiseV2G
        maven \
        # required for user and capability support in everest-framework >= 0.9.0
        libcap-dev

# clean up apt
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install \
    environs>=9.5.0 \
    pydantic==1.* \
    psutil>=5.9.1 \
    cryptography>=3.4.6 \
    aiofile>=3.7.4 \
    py4j>=0.10.9.5 \
    netifaces>=0.11.0 \
    python-dateutil>=2.8.2 \
    gcovr==5.0 \
    build

# install edm
RUN python3 -m pip install git+https://github.com/EVerest/everest-dev-environment@v0.5.5#subdirectory=dependency_manager

# install everest-cmake
RUN git clone https://github.com/EVerest/everest-cmake.git $EVEREST_CMAKE_PATH

RUN ( \
    cd $EVEREST_CMAKE_PATH \
    git checkout v0.4.0 \
    rm -r .git \
    )

# FIXME (aw): disable ownership check
RUN git config --global --add safe.directory '*'

ENV WORKSPACE_PATH /workspace
ENV ASSETS_PATH /assets

RUN mkdir $ASSETS_PATH
COPY maven-settings.xml $ASSETS_PATH/

ENV EXT_MOUNT $EXT_MOUNT

COPY ./entrypoint.sh /

WORKDIR $WORKSPACE_PATH

COPY deprecated_wrapper /
ENTRYPOINT ["/deprecated_wrapper"]
CMD ["run-script", "init"]
