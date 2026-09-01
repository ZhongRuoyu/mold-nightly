# Copyright (c) 2023 Rui Ueyama. Licensed under the MIT License.
# https://github.com/rui314/mold/blob/main/LICENSE

FROM mirror.gcr.io/riscv64/debian:unstable-20240926@sha256:25654919c2926f38952cdd14b3300d83d13f2d820715f78c9f4b7a1d9399bf48
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN sed -i -e '/^URIs/d' -e 's/^# http/URIs: http/' /etc/apt/sources.list.d/debian.sources && \
  echo 'Acquire::Retries "10"; Acquire::http::timeout "10"; Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/80-retries && \
  apt-get update && \
  apt-get install -y --no-install-recommends build-essential gcc-14 g++-14 clang-18 cmake git && \
  ln -sf /usr/bin/clang-18 /usr/bin/clang && \
  ln -sf /usr/bin/clang++-18 /usr/bin/clang++ && \
  rm -rf /var/lib/apt/lists
