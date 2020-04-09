FROM debian:jessie

MAINTAINER Szymon Magrian szymon.magrian1@gmail.com

ENV DEBIAN_FRONTEND noninteractive

# Microchip Tools Require i386 Compatability as Dependency

RUN dpkg --add-architecture i386 \
    && apt-get update -yq \
    && apt-get upgrade -yq \
    && apt-get install -yq --no-install-recommends build-essential bzip2 cpio curl python unzip wget \
    libc6:i386 libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 \
    libxext6 libxrender1 libxtst6 libgtk2.0-0 libxslt1.1 libncurses5-dev bzip2 \
	ca-certificates \
	ssh-client \
	git \
	unzip \
	xz-utils

# Download and Install XC8 Compiler, v1.38

RUN curl -fSL -A "Mozilla/4.0" -o /tmp/xc8.run "http://ww1.microchip.com/downloads/en/DeviceDoc/xc8-v1.38-full-install-linux-installer.run" \
    && chmod a+x /tmp/xc8.run \
    && /tmp/xc8.run --mode unattended --unattendedmodeui none \
        --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc8 \
    && rm /tmp/xc8.run

ENV PATH $PATH:/opt/microchip/xc8/bin

RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.5/cmake-3.15.5-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /usr/bin/cmake \
      && /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake \
      && rm /tmp/cmake-install.sh

ENV PATH $PATH:/usr/bin/cmake/bin

# Container Tool Version Reports to Build Log

RUN [ -x /opt/microchip/xc8/bin/xc8 ] && xc8 --ver
