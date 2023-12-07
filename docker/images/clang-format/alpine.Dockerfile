# syntax=docker/dockerfile:1
FROM python:3.11.4-alpine3.18

ARG RUN_CLANG_FORMAT_URL=https://raw.githubusercontent.com/Sarcasm/run-clang-format/39081c9c42768ab5e8321127a7494ad1647c6a2f/run-clang-format.py
RUN wget -O /usr/bin/run-clang-format.py "$RUN_CLANG_FORMAT_URL" && \
    chmod a+x /usr/bin/run-clang-format.py

ARG STATIC_CLANG_FORMAT_URL=https://github.com/muttleyxd/clang-tools-static-binaries/releases/download/master-8f72ab3c/clang-format-17_linux-amd64
RUN wget -O  /usr/bin/clang-format "$STATIC_CLANG_FORMAT_URL" && \
    chmod a+x /usr/bin/clang-format

ENTRYPOINT ["/usr/bin/run-clang-format.py"]
