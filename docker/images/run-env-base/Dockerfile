# syntax=docker/dockerfile:1
FROM debian:12-slim

# renovate: datasource=repology depName=debian_12/openjdk-17 versioning=loose
ENV OPENJDK_17_JRE_VERSION=17.0.12+7-2~deb12u1
# renovate: datasource=repology depName=debian_12/nodejs versioning=loose
ENV NODEJS_VERSION=18.19.0+dfsg-6~deb12u2
# renovate: datasource=repology depName=debian_12/npm versioning=loose
ENV NPM_VERSION=9.2.0~ds1-1
# renovate: datasource=repology depName=debian_12/python3-pip versioning=loose
ENV PYTHON3_PIP_VERSION=23.0.1+dfsg-1
# renovate: datasource=repology depName=debian_12/sqlite3 versioning=loose
ENV SQLITE3_VERSION=3.40.1-2
# renovate: datasource=repology depName=debian_12/boost1.74 versioning=loose
ENV LIBBOOST_PROGRAM_OPTIONS1_74_0_VERSION=1.74.0+ds1-21
# renovate: datasource=repology depName=debian_12/boost1.74 versioning=loose
ENV LIBBOOST_LOG1_74_0_VERSION=1.74.0+ds1-21
# renovate: datasource=repology depName=debian_12/boost1.74 versioning=loose
ENV LIBBOOST_CHRONO1_74_0_VERSION=1.74.0+ds1-21
# renovate: datasource=repology depName=debian_12/boost1.74 versioning=loose
ENV LIBBOOST_SYSTEM1_74_0_VERSION=1.74.0+ds1-21
# renovate: datasource=repology depName=debian_12/openssl versioning=loose
ENV LIBSSL3_VERSION=3.0.14-1~deb12u1
# renovate: datasource=repology depName=debian_12/curl versioning=loose
ENV LIBCURL4_VERSION=7.88.1-10+deb12u7
# renovate: datasource=repology depName=debian_12/libcap2 versioning=loose
ENV LIBCAP2_VERSION=1:2.66-4
# renovate: datasource=repology depName=debian_12/less versioning=loose
ENV LESS_VERSION=590-2.1~deb12u2
# renovate: datasource=repology depName=debian_12/python3-pydantic versioning=loose
ENV PYTHON3_PYDANTIC_VERSION=1.10.4-1
# renovate: datasource=repology depName=debian_12/python-cryptography versioning=loose
ENV PYTHON3_CRYPTOGRAPHY_VERSION=38.0.4-3~deb12u1
# renovate: datasource=repology depName=debian_12/python3-netifaces versioning=loose
ENV PYTHON3_NETIFACES_VERSION=0.11.0-2+b1
# renovate: datasource=repology depName=debian_12/python3-psutil versioning=loose
ENV PYTHON3_PSUTIL_VERSION=5.9.4-1+b1
# renovate: datasource=repology depName=debian_12/python3-dateutil versioning=loose
ENV PYTHON3_DATEUTIL_VERSION=2.8.2-2

RUN apt update \
    && apt install --no-install-recommends -y \
    openjdk-17-jre=${OPENJDK_17_JRE_VERSION} \
    nodejs=${NODEJS_VERSION} \
    npm=${NPM_VERSION} \
    python3-pip=${PYTHON3_PIP_VERSION} \
    sqlite3=${SQLITE3_VERSION} \
    libboost-program-options1.74.0=${LIBBOOST_PROGRAM_OPTIONS1_74_0_VERSION} \
    libboost-log1.74.0=${LIBBOOST_LOG1_74_0_VERSION} \
    libboost-chrono1.74.0=${LIBBOOST_CHRONO1_74_0_VERSION} \
    libboost-system1.74.0=${LIBBOOST_SYSTEM1_74_0_VERSION} \
    libssl3=${LIBSSL3_VERSION} \
    libcurl4=${LIBCURL4_VERSION} \
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
ENV ENVIRONS_VERSION=11.0.0
# renovate: datasource=pypi depName=py4j
ENV PY4J_VERSION=0.10.9.7
# renovate: datasource=pypi depName=aiofile
ENV AIOFILE_VERSION=3.8.8

RUN python3 -m pip install --break-system-packages \
    environs==${ENVIRONS_VERSION} \
    py4j==${PY4J_VERSION} \
    aiofile==${AIOFILE_VERSION}
