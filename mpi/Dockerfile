FROM ubuntu:22.04

RUN    apt update                                                                               \
    && apt install --no-install-recommends --yes build-essential libopenmpi-dev openmpi-bin ssh \
    && rm -rf /var/lib/apt/lists/*

COPY main.c /opt/main.c
RUN  mpicxx /opt/main.c -o /opt/main
