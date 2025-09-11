# syntax=docker/dockerfile:1
ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/everest/everest-ci/run-env-base:${BASE_IMAGE_TAG}

# renovate: datasource=repology depName=debian_13/git versioning=loose
ENV GIT_VERSION=1:2.47.3-0+deb13u1
# renovate: datasource=repology depName=debian_13/curl versioning=loose
ENV CURL_VERSION=8.14.1-2
# renovate: datasource=repology depName=debian_13/rsync versioning=loose
ENV RSYNC_VERSION=3.4.1+ds1-5
# renovate: datasource=repology depName=debian_13/ninja-build versioning=loose
ENV NINJA_BUILD_VERSION=1.12.1-1
# renovate: datasource=repology depName=debian_13/make-dfsg versioning=loose
ENV MAKE_VERSION=4.4.1-2
# renovate: datasource=repology depName=debian_13/cmake versioning=loose
ENV CMAKE_VERSION=3.31.6-2
# renovate: datasource=repology depName=debian_13/binutils versioning=loose
ENV BINUTILS_VERSION=2.44-3
# renovate: datasource=repology depName=debian_13/gcc versioning=loose
ENV GCC_VERSION=4:14.2.0-1
# renovate: datasource=repology depName=debian_13/g++ versioning=loose
ENV GPP_VERSION=4:14.2.0-1
# renovate: datasource=repology depName=debian_13/ccache versioning=loose
ENV CCACHE_VERSION=4.11.2-2
# renovate: datasource=repology depName=debian_13/lcov versioning=loose
ENV LCOV_VERSION=2.3.1-1
# renovate: datasource=repology depName=debian_13/clang-format versioning=loose
ENV CLANG_FORMAT_VERSION=1:19.0-63
# renovate: datasource=repology depName=debian_13/clang-tidy versioning=loose
ENV CLANG_TIDY_VERSION=1:19.0-63
# renovate: datasource=repology depName=debian_13/doxygen versioning=loose
ENV DOXYGEN_VERSION=1.9.8+ds-2.1

RUN apt update \
    && apt install --no-install-recommends -y \
    # basic command line tools
    git=${GIT_VERSION} \
    curl=${CURL_VERSION} \
    rsync=${RSYNC_VERSION} \
    # build tools
    ninja-build=${NINJA_BUILD_VERSION} \
    make=${MAKE_VERSION} \
    cmake=${CMAKE_VERSION} \
    # compilers
    binutils=${BINUTILS_VERSION} \
    gcc=${GCC_VERSION} \
    g++=${GPP_VERSION} \
    # compiler tools
    ccache=${CCACHE_VERSION} \
    lcov=${LCOV_VERSION} \
    clang-format=${CLANG_FORMAT_VERSION} \
    clang-tidy=${CLANG_TIDY_VERSION} \
    # documentation
    doxygen=${DOXYGEN_VERSION}

COPY run-clang-format.py /usr/bin/run-clang-format

# renovate: datasource=repology depName=debian_13/boost-defaults versioning=loose
ENV LIBBOOST_ALL_DEV_VERSION=1.83.0.2+b2
# renovate: datasource=repology depName=debian_13/libsqlite3-dev versioning=loose
ENV LIBSQLITE3_DEV_VERSION=3.46.1-7
# renovate: datasource=repology depName=debian_13/openssl versioning=loose
ENV LIBSSL_DEV_VERSION=3.5.1-1
# renovate: datasource=repology depName=debian_13/nodejs versioning=loose
ENV LIBNODE_DEV_VERSION=20.19.2+dfsg-1
# renovate: datasource=repology depName=debian_13/pkg-config versioning=loose
ENV PKG_CONFIG_VERSION=1.8.1-4
# renovate: datasource=repology depName=debian_13/libpcap-dev versioning=loose
ENV LIBPCAP_DEV_VERSION=1.10.5-2
# renovate: datasource=repology depName=debian_13/libcap versioning=loose
ENV LIBCAP_DEV_VERSION=1:2.75-10+b1
# renovate: datasource=repology depName=debian_13/python3-venv versioning=loose
ENV PYTHON3_VENV_VERSION=3.13.5-1
# renovate: datasource=repology depName=debian_13/python3-build versioning=loose
ENV PYTHON3_BUILD_VERSION=1.2.2-2
# renovate: datasource=repology depName=debian_13/sphinx versioning=loose
ENV PYTHON3_SPHINX_VERSION=8.1.3-5

# additional packages
RUN apt update \
    && apt install --no-install-recommends -y \
    # required by some everest libraries
    libboost-all-dev=${LIBBOOST_ALL_DEV_VERSION} \
    # required by libocpp
    libsqlite3-dev=${LIBSQLITE3_DEV_VERSION} \
    libssl-dev=${LIBSSL_DEV_VERSION} \
    # required by everest-framework
    libnode-dev=${LIBNODE_DEV_VERSION} \
    # required by packet sniffer module
    pkg-config=${PKG_CONFIG_VERSION} \
    libpcap-dev=${LIBPCAP_DEV_VERSION} \
    libcap-dev=${LIBCAP_DEV_VERSION} \
    # Install Python packages
    # Install Python packages - general
    python3-venv=${PYTHON3_VENV_VERSION} \
    # Install Python packages - required by everest-core to run integration tests
    python3-build=${PYTHON3_BUILD_VERSION} \
    # Install Python packages- required to build documentation
    python3-sphinx=${PYTHON3_SPHINX_VERSION}

RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

# renovate: datasource=pypi depName=gcovr
ENV GCOVR_VERSION=8.3
# renovate: datasource=pypi depName=sphinxcontrib-contentui
ENV SPHINXCONTRIB_CONTENTUI_VERSION=0.2.5
# renovate: datasource=pypi depName=sphinxcontrib-svg2pdfconverter
ENV SPHINXCONTRIB_SVG2PDFCONVERTER_VERSION=1.3.0

# Install additional Python packages
RUN python3 -m pip install --break-system-packages \
    gcovr==${GCOVR_VERSION} \
    #Required by documentation - Sphinx extensions
    sphinxcontrib-contentui==${SPHINXCONTRIB_CONTENTUI_VERSION} \
    sphinxcontrib-svg2pdfconverter==${SPHINXCONTRIB_SVG2PDFCONVERTER_VERSION}

# renovate: datasource=github-releases depName=EVerest/everest-dev-environment versioning=loose
ENV EDM_VERSION=v0.8.0

# Install EVerest dependency manager
RUN python3 -m pip install --break-system-packages \
    git+https://github.com/EVerest/everest-dev-environment@${EDM_VERSION}#subdirectory=dependency_manager

# Install everest-cmake
ENV EVEREST_CMAKE_PATH=/usr/lib/cmake/everest-cmake
# renovate: datasource=github-releases depName=EVerest/everest-cmake versioning=loose
ENV EVEREST_CMAKE_VERSION=v0.5.4
RUN git clone https://github.com/EVerest/everest-cmake.git ${EVEREST_CMAKE_PATH} \
    && cd ${EVEREST_CMAKE_PATH} \
    && git checkout ${EVEREST_CMAKE_VERSION} \
    && rm -r .git

COPY entrypoint.sh /entrypoint.sh
ARG TARGETARCH
COPY entrypoint_wrapper.sh /entrypoint_wrapper.sh
RUN if [ ${TARGETARCH} != "amd64" ]; then \
        mv /entrypoint.sh /wrapped_entrypoint.sh; \
        cp /entrypoint_wrapper.sh /entrypoint.sh; \
    fi; \
    rm /entrypoint_wrapper.sh
ENTRYPOINT [ "/entrypoint.sh" ]
