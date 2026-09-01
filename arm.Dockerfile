# Copyright (c) 2023 Rui Ueyama. Licensed under the MIT License.
# https://github.com/rui314/mold/blob/main/LICENSE

FROM mirror.gcr.io/library/debian:bullseye-20240904@sha256:8ccc486c29a3ad02ad5af7f1156e2152dff3ba5634eec9be375269ef123457d8
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN sed -i -e '/^deb/d' -e 's/^# deb /deb /g' /etc/apt/sources.list && \
  echo 'Acquire::Retries "10"; Acquire::http::timeout "10"; Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/80-retries && \
  apt-get update && \
  apt-get install -y --no-install-recommends build-essential gcc-10 g++-10 clang-16 cmake git && \
  ln -sf /usr/bin/clang-16 /usr/bin/clang && \
  ln -sf /usr/bin/clang++-16 /usr/bin/clang++ && \
  rm -rf /var/lib/apt/lists
