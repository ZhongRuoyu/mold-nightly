# Copyright (c) 2023 Rui Ueyama. Licensed under the MIT License.
# https://github.com/rui314/mold/blob/main/LICENSE

FROM mirror.gcr.io/library/debian:stretch@sha256:c5c5200ff1e9c73ffbf188b4a67eb1c91531b644856b4aefe86a58d2f0cb05be
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN sed -i -e '/^deb/d' -e 's/^# deb /deb /g' /etc/apt/sources.list && \
  echo 'Acquire::Retries "10"; Acquire::http::timeout "10"; Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/80-retries && \
  apt-get update && \
  apt-get install -y --no-install-recommends wget xz-utils file make gcc g++ git zlib1g-dev libssl-dev ca-certificates && \
  rm -rf /var/lib/apt/lists

# Build CMake 3.27
RUN mkdir /build && \
  cd /build && \
  wget --progress=dot:mega https://cmake.org/files/v3.27/cmake-3.27.7.tar.gz && \
  echo '08f71a106036bf051f692760ef9558c0577c42ac39e96ba097e7662bd4158d8e cmake-3.27.7.tar.gz' | sha256sum -c && \
  tar xf cmake-3.27.7.tar.gz --strip-components=1 && \
  ./bootstrap --parallel=$(nproc) && \
  make -j$(nproc) && \
  make install && \
  rm -rf /build

# Build GCC 14
RUN mkdir /build && \
  cd /build && \
  wget --progress=dot:mega https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz && \
  echo 'a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9 gcc-14.2.0.tar.xz' | sha256sum -c && \
  tar xf gcc-14.2.0.tar.xz --strip-components=1 && \
  mkdir gmp mpc mpfr && \
  wget --progress=dot:mega https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz && \
  echo 'a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898 gmp-6.3.0.tar.xz' | sha256sum -c && \
  tar xf gmp-6.3.0.tar.xz --strip-components=1 -C gmp && \
  wget --progress=dot:mega https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz && \
  echo 'ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8 mpc-1.3.1.tar.gz' | sha256sum -c && \
  tar xf mpc-1.3.1.tar.gz --strip-components=1 -C mpc && \
  wget --progress=dot:mega https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz && \
  echo '277807353a6726978996945af13e52829e3abd7a9a5b7fb2793894e18f1fcbb2 mpfr-4.2.1.tar.xz' | sha256sum -c && \
  tar xf mpfr-4.2.1.tar.xz --strip-components=1 -C mpfr && \
  ./configure --prefix=/usr --enable-languages=c,c++ --disable-bootstrap --disable-multilib && \
  make -j$(nproc) && \
  make install && \
  ln -sf /usr/lib64/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6 && \
  rm -rf /build

# Build GNU binutils 2.43
RUN mkdir /build && \
  cd /build && \
  wget --progress=dot:mega https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.xz && \
  echo 'b53606f443ac8f01d1d5fc9c39497f2af322d99e14cea5c0b4b124d630379365 binutils-2.43.tar.xz' | sha256sum -c && \
  tar xf binutils-2.43.tar.xz --strip-components=1 && \
  ./configure --prefix=/usr && \
  make -j$(nproc) && \
  make install && \
  rm -fr /build

# Build Python 3.12.7
RUN mkdir /build && \
  cd /build && \
  wget --progress=dot:mega https://www.python.org/ftp/python/3.12.7/Python-3.12.7.tar.xz && \
  echo '24887b92e2afd4a2ac602419ad4b596372f67ac9b077190f459aba390faf5550 Python-3.12.7.tar.xz' | sha256sum -c && \
  tar xf Python-3.12.7.tar.xz --strip-components=1 && \
  ./configure && \
  make -j$(nproc) && \
  make install && \
  rm -rf /build

# Build LLVM 20
RUN mkdir /build && \
  cd /build && \
  wget --progress=dot:mega https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/llvm-project-20.1.3.src.tar.xz && \
  echo 'b6183c41281ee3f23da7fda790c6d4f5877aed103d1e759763b1008bdd0e2c50 llvm-project-20.1.3.src.tar.xz' | sha256sum -c && \
  tar xf llvm-project-20.1.3.src.tar.xz --strip-components=1 && \
  mkdir b && \
  cd b && \
  cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=clang ../llvm && \
  cmake --build . -j$(nproc) && \
  cmake --install . --strip && \
  rm -rf /build
