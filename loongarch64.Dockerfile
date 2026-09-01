# Copyright (c) 2023 Rui Ueyama. Licensed under the MIT License.
# https://github.com/rui314/mold/blob/main/LICENSE

FROM mirror.gcr.io/loongarch64/debian:sid@sha256:0356df4e494bbb86bb469377a00789a5b42bbf67d5ff649a3f9721b745cbef77
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN echo 'deb http://deb.debian.org/debian sid main' > /etc/apt/sources.list && \
  echo 'Acquire::Retries "10"; Acquire::http::timeout "10"; Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/80-retries && \
  apt-get update && \
  apt-get install -y --no-install-recommends build-essential gcc-14 g++-14 clang-19 cmake git && \
  ln -sf /usr/bin/clang-19 /usr/bin/clang && \
  ln -sf /usr/bin/clang++-19 /usr/bin/clang++ && \
  rm -rf /var/lib/apt/lists
