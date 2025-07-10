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
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       wine wget unzip cabextract \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       wine32 wine64 \
    # Download and install the latest winetricks
    && wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x winetricks \
    && mv winetricks /usr/local/bin \
    # Now run the updated winetricks
    && xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" winetricks -q --force vcrun2019 \
    && wget https://lastools.github.io/download/LAStools.zip \
    && unzip LAStools.zip \
    && wine LAStools/bin/las2las -h \
    # Clean up apt caches to reduce image size
    && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh
WORKDIR /lastools
ENTRYPOINT ["/entrypoint.sh"]




