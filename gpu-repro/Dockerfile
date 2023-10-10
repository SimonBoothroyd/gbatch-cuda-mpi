ARG CUDA_VERSION=12.0.0
ARG OMPI_VERSION=4.1.5

FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu22.04 as builder

COPY main.cu /opt/main.cu

ARG CUDA_VERSION
ARG OMPI_VERSION

ENV OMPI_DIR=/opt/openmpi
ENV OMPI_URL="https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-${OMPI_VERSION}.tar.bz2"

ENV PATH=/opt/openmpi/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/openmpi/lib:${LD_LIBRARY_PATH}

RUN    apt update                                                                   \
    && apt install --no-install-recommends --yes wget build-essential ssh           \
                                                                                    \
    && mkdir -p /tmp/openmpi                                                        \
    && mkdir -p /opt                                                                \
    && cd /tmp/openmpi                                                              \
    && wget -O openmpi-${OMPI_VERSION}.tar.bz2 $OMPI_URL                            \
    && tar -xjf openmpi-${OMPI_VERSION}.tar.bz2                                     \
    && cd /tmp/openmpi/openmpi-${OMPI_VERSION}                                      \
    && ./configure --prefix=$OMPI_DIR --with-cuda                                   \
    && make -j $(nproc)                                                             \
    && make install                                                                 \
    && cd /                                                                         \
                                                                                    \
    && nvcc /opt/main.cu -I/opt/openmpi/include                                     \
                         -L/opt/openmpi/lib -lmpi -o /opt/main

FROM nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu22.04

COPY --from=builder ${OMPI_DIR} ${OMPI_DIR}
COPY --from=builder /opt/main /opt/main

RUN    apt update                                                    \
    && apt install --no-install-recommends --yes build-essential ssh \
    && rm -rf /var/lib/apt/lists/*
