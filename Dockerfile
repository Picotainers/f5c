# syntax=docker/dockerfile:1

FROM ubuntu:22.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG F5C_VERSION=v1.6
ARG F5C_SHA256=cb2cfe55c154fff16a6c05392d98db6e48a49ef9245a397b46ddfb0f9e3be255

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    zlib1g-dev \
    libhdf5-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget -O f5c-release.tar.gz "https://github.com/hasindu2008/f5c/releases/download/${F5C_VERSION}/f5c-${F5C_VERSION}-release.tar.gz" \
    && echo "${F5C_SHA256}  f5c-release.tar.gz" | sha256sum -c - \
    && tar -xzf f5c-release.tar.gz \
    && cd "f5c-${F5C_VERSION}" \
    && ./scripts/install-hts.sh \
    && ./configure \
    && make -j"$(nproc)" \
    && make install

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    zlib1g \
    libhdf5-103-1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/f5c /usr/local/bin/f5c
COPY --from=builder /usr/local/share/man/man1/f5c.1.gz /usr/local/share/man/man1/f5c.1.gz

WORKDIR /data
ENTRYPOINT ["f5c"]
