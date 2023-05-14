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
        python3-pip

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
        maven

# clean up apt
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install ev-cli
RUN python3 -m pip install git+https://github.com/EVerest/everest-utils@bfe50ec#subdirectory=ev-dev-tools

# install everest-testing
RUN python3 -m pip install git+https://github.com/EVerest/everest-utils@8269e2c#subdirectory=everest-testing

# install edm
RUN python3 -m pip install git+https://github.com/EVerest/everest-dev-environment@dbf310f#subdirectory=dependency_manager

# install everest-cmake
RUN git clone https://github.com/EVerest/everest-cmake.git $EVEREST_CMAKE_PATH

RUN ( \
    cd $EVEREST_CMAKE_PATH \
    git checkout 329f8db \
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

ENTRYPOINT ["/entrypoint.sh"]
CMD ["run-script", "init"]
