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
        python3-dev \
	# required for certificate generation
	openssl

RUN python3 -m pip install \
    environs>=9.5.0 \
    pydantic==1.* \
    psutil>=5.9.1 \
    cryptography>=3.4.6 \
    aiofile>=3.7.4 \
    py4j>=0.10.9.5 \
    netifaces>=0.11.0 \
    python-dateutil>=2.8.2

# install ev-cli
RUN python3 -m pip install git+https://github.com/EVerest/everest-utils@b862a940afa37a99350483fd550e88acaff3e9a7#subdirectory=ev-dev-tools

# install everest-testing
RUN python3 -m pip install git+https://github.com/EVerest/everest-utils@v0.1.4#subdirectory=everest-testing

# install edm
RUN python3 -m pip install git+https://github.com/EVerest/everest-dev-environment@v0.5.5#subdirectory=dependency_manager

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
