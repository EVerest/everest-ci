# syntax=docker/dockerfile:1
FROM debian:12-slim

RUN apt update \
    && apt install --no-install-recommends -y \
    openjdk-17-jre=17.0.11+9-1~deb12u1 \
    nodejs=18.19.0+dfsg-6~deb12u2 \
    npm=9.2.0~ds1-1 \
    python3-pip=23.0.1+dfsg-1 \
    sqlite3=3.40.1-2 \
    libboost-program-options1.74.0=1.74.0+ds1-21 \
    libboost-log1.74.0=1.74.0+ds1-21 \
    libboost-chrono1.74.0=1.74.0+ds1-21 \
    libboost-system1.74.0=1.74.0+ds1-21 \
    libssl3=3.0.13-1~deb12u1 \
    libcurl4=7.88.1-10+deb12u5 \
    libcap2=1:2.66-4 \
    less=590-2.1~deb12u2 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
