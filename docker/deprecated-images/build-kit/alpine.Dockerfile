# syntax=docker/dockerfile:1
FROM alpine:3.21

ARG EXT_MOUNT=/ext
ARG EVEREST_CMAKE_PATH=/usr/lib/cmake/everest-cmake

RUN apk update && \
    apk add --no-cache \
        # basic command line tools
        git \
        curl \
        rsync \
        bash \
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
        py3-pip \
        # required for testing
        gtest-dev


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
        python3-dev \
        # required for certificate generation
        openssl \
        # required for user and capability support in everest-framework >= 0.9.0
        libcap-dev

# Add edge/testing repository to enable installation of lcov, which is not available in the main repository
RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk update && apk add --no-cache \
        lcov=2.0-r2

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
