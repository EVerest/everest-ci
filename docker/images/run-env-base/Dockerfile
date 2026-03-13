# syntax=docker/dockerfile:1
FROM debian:12-slim

RUN apt update \
    && apt install --no-install-recommends -y \
    openjdk-17-jre \
    nodejs \
    npm \
    python3-pip \
    sqlite3 \
    libboost-program-options1.74.0 \
    libboost-log1.74.0 \
    libboost-chrono1.74.0 \
    libboost-system1.74.0 \
    libssl3 \
    libcurl4 \
    libcap2 \
    less \
    python3-pydantic \
    python3-cryptography \
    python3-netifaces \
    python3-psutil \
    python3-dateutil \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --break-system-packages \
    environs \
    py4j \
    aiofile

COPY ../../../applications/utils/scripts/package_version_logger.py /usr/local/bin/package_version_logger.py
RUN package_version_logger.py --output-file /package_inventory.json

COPY entrypoint.sh /entrypoint.sh
ARG TARGETARCH
COPY entrypoint_wrapper.sh /entrypoint_wrapper.sh
RUN if [ ${TARGETARCH} != "amd64" ]; then \
        mv /entrypoint.sh /wrapped_entrypoint.sh; \
        cp /entrypoint_wrapper.sh /entrypoint.sh; \
    fi; \
    rm /entrypoint_wrapper.sh
ENTRYPOINT [ "/entrypoint.sh" ]
