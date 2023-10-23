ARG CUDA_VERSION=12.0.0

FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu22.04 as builder

COPY main.cu /opt/main.cu

RUN    apt update                                                                               \
    && apt install --no-install-recommends --yes build-essential libopenmpi-dev openmpi-bin ssh \
    && rm -rf /var/lib/apt/lists/*                                                              \
                                                                                                \
    && nvcc /opt/main.cu -I/usr/lib/x86_64-linux-gnu/openmpi/include                            \
                         -L/usr/lib/x86_64-linux-gnu/openmpi/lib -lmpi -o /opt/main

FROM nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu22.04

COPY --from=builder /opt/main /opt/main

ENV MY_ENV_VAR=1234

RUN    apt update                                                \
    && apt install --no-install-recommends --yes openmpi-bin ssh \
    && rm -rf /var/lib/apt/lists/*
