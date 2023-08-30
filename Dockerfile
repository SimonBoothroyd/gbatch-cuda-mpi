FROM nvidia/cuda:12.0.0-runtime-ubuntu22.04

COPY run.sh /opt/run.sh

RUN    apt update                                                \
    && apt install --no-install-recommends --yes openmpi-bin ssh \
    && rm -rf /var/lib/apt/lists/*                               \
    && chmod 777 /opt/run.sh
