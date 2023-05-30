# syntax=docker/dockerfile:1
FROM alpine:3.17

ARG EXT_MOUNT=/ext
ARG EVEREST_CMAKE_PATH=/usr/lib/cmake/everest-cmake

RUN apk update && \
    apk add --no-cache \
        # basic command line tools
        git \
        curl \
        rsync \
        # build tools
        samurai \
        make \
        cmake \
        # compilers
        binutils \
        gcc \
        g++ \
        # common dev libraries
        musl-dev \
        linux-headers \
        # compiler tools
        clang-extra-tools \
        ccache \
        # python3 support
        py3-pip

# additional packages
RUN apk add --no-cache \
        # required by timezone handling
        tzdata \
        # required by some everest libraries
        boost-dev \
        # required by libocpp
        sqlite-dev \
        openssl-dev \
        # required by everest-framework
        nodejs-dev \
        nodejs \
        npm \
        # required by packet sniffer module
        libpcap-dev \
        libevent-dev \
        # required by RiseV2G
        maven \
        # required by pybind11
        python3-dev


# install ev-cli
RUN python3 -m pip install git+https://github.com/EVerest/everest-utils@246f250#subdirectory=ev-dev-tools

# install everest-testing
RUN python3 -m pip install git+https://github.com/EVerest/everest-utils@c7b3cc6#subdirectory=everest-testing

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
