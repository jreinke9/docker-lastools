FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    apt-transport-https \
    lsb-release \
    gnupg \
    ca-certificates \
    xvfb \
    && curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin
ENV WINEDEBUG=err
ENV DISPLAY=:0.0

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y wine wget unzip \
    # For some reason, we need a separate step for adding a wine32 architecture
    && dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y wine32 wine64 winetricks \
    && xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" winetricks -q vcrun2015 vcrun2017 vcrun2019 \
    && wget https://lastools.github.io/download/LAStools.zip \
    && unzip LAStools.zip \
    # Run one program to configure wine
    && wine LAStools/bin/las2las -h
COPY entrypoint.sh /entrypoint.sh
WORKDIR /lastools
ENTRYPOINT ["/entrypoint.sh"]




