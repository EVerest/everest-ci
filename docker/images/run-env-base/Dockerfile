# syntax=docker/dockerfile:1
FROM debian:13-slim

# renovate: datasource=repology depName=debian_13/openjdk-21 versioning=loose
ENV OPENJDK_21_JRE_VERSION=21.0.8+9-1
# renovate: datasource=repology depName=debian_13/nodejs versioning=loose
ENV NODEJS_VERSION=20.19.2+dfsg-1
# renovate: datasource=repology depName=debian_13/npm versioning=loose
ENV NPM_VERSION=9.2.0~ds1-3
# renovate: datasource=repology depName=debian_13/python3-pip versioning=loose
ENV PYTHON3_PIP_VERSION=25.1.1+dfsg-1
# renovate: datasource=repology depName=debian_13/sqlite3 versioning=loose
ENV SQLITE3_VERSION=3.46.1-7
# renovate: datasource=repology depName=debian_13/boost1.88 versioning=loose
ENV LIBBOOST_PROGRAM_OPTIONS1_88_0_VERSION=1.88.0-1
# renovate: datasource=repology depName=debian_13/boost1.88 versioning=loose
ENV LIBBOOST_LOG1_88_0_VERSION=1.88.0-1
# renovate: datasource=repology depName=debian_13/boost1.88 versioning=loose
ENV LIBBOOST_CHRONO1_88_0_VERSION=1.88.0-1
# renovate: datasource=repology depName=debian_13/boost1.88 versioning=loose
ENV LIBBOOST_SYSTEM1_88_0_VERSION=1.88.0-1
# renovate: datasource=repology depName=debian_13/openssl versioning=loose
ENV LIBSSL3_VERSION=3.5.1-1
# renovate: datasource=repology depName=debian_13/curl versioning=loose
ENV LIBCURL4_VERSION=8.14.1-2
# renovate: datasource=repology depName=debian_13/libcap2 versioning=loose
ENV LIBCAP2_VERSION=1:2.75-10+b1
# renovate: datasource=repology depName=debian_13/less versioning=loose
ENV LESS_VERSION=668-1
# renovate: datasource=repology depName=debian_13/python3-pydantic versioning=loose
ENV PYTHON3_PYDANTIC_VERSION=2.10.6-2
# renovate: datasource=repology depName=debian_13/python-cryptography versioning=loose
ENV PYTHON3_CRYPTOGRAPHY_VERSION=43.0.0-3
# renovate: datasource=repology depName=debian_13/python3-netifaces versioning=loose
ENV PYTHON3_NETIFACES_VERSION=0.11.0-2+b6
# renovate: datasource=repology depName=debian_13/python3-psutil versioning=loose
ENV PYTHON3_PSUTIL_VERSION=7.0.0-2
# renovate: datasource=repology depName=debian_13/python3-dateutil versioning=loose
ENV PYTHON3_DATEUTIL_VERSION=2.9.0-4

RUN apt update \
    && apt install --no-install-recommends -y \
    openjdk-21-jre=${OPENJDK_21_JRE_VERSION} \
    nodejs=${NODEJS_VERSION} \
    npm=${NPM_VERSION} \
    python3-pip=${PYTHON3_PIP_VERSION} \
    sqlite3=${SQLITE3_VERSION} \
    libboost-program-options1.88.0=${LIBBOOST_PROGRAM_OPTIONS1_88_0_VERSION} \
    libboost-log1.88.0=${LIBBOOST_LOG1_88_0_VERSION} \
    libboost-chrono1.88.0=${LIBBOOST_CHRONO1_88_0_VERSION} \
    libboost-log1.88.0=${LIBBOOST_LOG1_88_0_VERSION} \
    libssl3t64=${LIBSSL3_VERSION} \
    libcurl4t64=${LIBCURL4_VERSION} \
    libcap2=${LIBCAP2_VERSION} \
    less=${LESS_VERSION} \
    python3-pydantic=${PYTHON3_PYDANTIC_VERSION} \
    python3-cryptography=${PYTHON3_CRYPTOGRAPHY_VERSION} \
    python3-netifaces=${PYTHON3_NETIFACES_VERSION} \
    python3-psutil=${PYTHON3_PSUTIL_VERSION} \
    python3-dateutil=${PYTHON3_DATEUTIL_VERSION} \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# renovate: datasource=pypi depName=environs
ENV ENVIRONS_VERSION=14.3.0
# renovate: datasource=pypi depName=py4j
ENV PY4J_VERSION=0.10.9.7
# renovate: datasource=pypi depName=aiofile
ENV AIOFILE_VERSION=3.9.0

RUN python3 -m pip install --break-system-packages \
    environs==${ENVIRONS_VERSION} \
    py4j==${PY4J_VERSION} \
    aiofile==${AIOFILE_VERSION}

COPY entrypoint.sh /entrypoint.sh
ARG TARGETARCH
COPY entrypoint_wrapper.sh /entrypoint_wrapper.sh
RUN if [ ${TARGETARCH} != "amd64" ]; then \
        mv /entrypoint.sh /wrapped_entrypoint.sh; \
        cp /entrypoint_wrapper.sh /entrypoint.sh; \
    fi; \
    rm /entrypoint_wrapper.sh
ENTRYPOINT [ "/entrypoint.sh" ]
