# syntax=docker/dockerfile:1
ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/everest/everest-ci/run-env-base:${BASE_IMAGE_TAG}

# renovate: datasource=repology depName=debian_12/git versioning=loose
ENV GIT_VERSION=1:2.39.5-0+deb12u1
# renovate: datasource=repology depName=debian_12/curl versioning=loose
ENV CURL_VERSION=7.88.1-10+deb12u7
# renovate: datasource=repology depName=debian_12/rsync versioning=loose
ENV RSYNC_VERSION=3.2.7-1
# renovate: datasource=repology depName=debian_12/ninja-build versioning=loose
ENV NINJA_BUILD_VERSION=1.11.1-1
# renovate: datasource=repology depName=debian_12/make-dfsg versioning=loose
ENV MAKE_VERSION=4.3-4.1
# renovate: datasource=repology depName=debian_12/cmake versioning=loose
ENV CMAKE_VERSION=3.25.1-1
# renovate: datasource=repology depName=debian_12/binutils versioning=loose
ENV BINUTILS_VERSION=2.40-2
# renovate: datasource=repology depName=debian_12/gcc versioning=loose
ENV GCC_VERSION=4:12.2.0-3
# renovate: datasource=repology depName=debian_12/g++ versioning=loose
ENV GPP_VERSION=4:12.2.0-3
# renovate: datasource=repology depName=debian_12/ccache versioning=loose
ENV CCACHE_VERSION=4.8+really4.7.5-1
# renovate: datasource=repology depName=debian_12/lcov versioning=loose
ENV LCOV_VERSION=1.16-1
# renovate: datasource=repology depName=debian_12/clang-format versioning=loose
ENV CLANG_FORMAT_VERSION=1:15.0.6-4+b1
# renovate: datasource=repology depName=debian_12/clang-tidy versioning=loose
ENV CLANG_TIDY_VERSION=1:15.0.6-4+b1

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
    clang-format-15=${CLANG_FORMAT_VERSION} \
    clang-tidy-15=${CLANG_TIDY_VERSION}

# Create symlinks for clang-format and clang-tidy
RUN ln -s /usr/bin/clang-format-15 /usr/bin/clang-format \
    && ln -s /usr/bin/clang-tidy-15 /usr/bin/clang-tidy

COPY run-clang-format.py /usr/bin/run-clang-format

# renovate: datasource=repology depName=debian_12/boost-defaults versioning=loose
ENV LIBBOOST_ALL_DEV_VERSION=1.74.0.3
# renovate: datasource=repology depName=debian_12/libsqlite3-dev versioning=loose
ENV LIBSQLITE3_DEV_VERSION=3.40.1-2
# renovate: datasource=repology depName=debian_12/openssl versioning=loose
ENV LIBSSL_DEV_VERSION=3.0.15-1~deb12u1
# renovate: datasource=repology depName=debian_12/nodejs versioning=loose
ENV LIBNODE_DEV_VERSION=18.19.0+dfsg-6~deb12u2
# renovate: datasource=repology depName=debian_12/pkg-config versioning=loose
ENV PKG_CONFIG_VERSION=1.8.1-1
# renovate: datasource=repology depName=debian_12/libpcap-dev versioning=loose
ENV LIBPCAP_DEV_VERSION=1.10.3-1
# renovate: datasource=repology depName=debian_12/libcap-dev versioning=loose
ENV LIBCAP_DEV_VERSION=1:2.66-4
# renovate: datasource=repology depName=debian_12/python3-venv versioning=loose
ENV PYTHON3_VENV_VERSION=3.11.2-1+b1
# renovate: datasource=repology depName=debian_12/python3-build versioning=loose
ENV PYTHON3_BUILD_VERSION=0.9.0-1
# renovate: datasource=repology depName=debian_12/sphinx versioning=loose
ENV PYTHON3_SPHINX_VERSION=5.3.0-4

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
ENV GCOVR_VERSION=7.2
# renovate: datasource=pypi depName=sphinxcontrib-contentui
ENV SPHINXCONTRIB_CONTENTUI_VERSION=0.2.5
# renovate: datasource=pypi depName=sphinxcontrib-svg2pdfconverter
ENV SPHINXCONTRIB_SVG2PDFCONVERTER_VERSION=1.2.3

# Install additional Python packages
RUN python3 -m pip install --break-system-packages \
    gcovr==${GCOVR_VERSION} \
    #Required by documentation - Sphinx extensions
    sphinxcontrib-contentui==${SPHINXCONTRIB_CONTENTUI_VERSION} \
    sphinxcontrib-svg2pdfconverter==${SPHINXCONTRIB_SVG2PDFCONVERTER_VERSION}

# renovate: datasource=github-releases depName=EVerest/everest-dev-environment versioning=loose
ENV EDM_VERSION=v0.6.2

# Install EVerest dependency manager
RUN python3 -m pip install --break-system-packages \
    git+https://github.com/EVerest/everest-dev-environment@${EDM_VERSION}#subdirectory=dependency_manager

# Install everest-cmake
ENV EVEREST_CMAKE_PATH=/usr/lib/cmake/everest-cmake
# renovate: datasource=github-releases depName=EVerest/everest-cmake versioning=loose
ENV EVEREST_CMAKE_VERSION=v0.5.0
RUN git clone https://github.com/EVerest/everest-cmake.git ${EVEREST_CMAKE_PATH} \
    && cd ${EVEREST_CMAKE_PATH} \
    && git checkout ${EVEREST_CMAKE_VERSION} \
    && rm -r .git
