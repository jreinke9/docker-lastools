FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    apt-transport-https \
    lsb-release \
    gnupg \
    ca-certificates \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && apt-get update \
    && apt-get install -y google-cloud-sdk

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y wine wget unzip \
    # For some reason, we need a separate step for adding a wine32 architecture
    && dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y wine32 \
    && wget https://lastools.github.io/download/LAStools.zip \
    && unzip LAStools.zip \
    # Run one program to configure wine
    && wine LAStools/bin/las2las -h
COPY entrypoint.sh /entrypoint.sh
WORKDIR /lastools
ENTRYPOINT ["/entrypoint.sh"]




