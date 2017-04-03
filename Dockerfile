FROM ubuntu:16.04
LABEL maintainer "Ligboy.Liu <ligboy@gmail.com>"

# Environments
# - Language
RUN locale-gen en_US.UTF-8
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"

# ------------------------------------------------------
# --- Base pre-installed tools
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && apt-get install -y --no-install-recommends \
    curl \
    debconf-utils \
    git \
    mercurial \
    python \
    python-software-properties \
    sudo \
    software-properties-common \
    tree \
    unzip \
    wget \
    zip

# ------------------------------------------------------
# --- SSH config
RUN mkdir -p /root/.ssh
COPY ./ssh/config /root/.ssh/config

# ------------------------------------------------------
# --- Git config
RUN git config --global user.email robot@meitu.com
RUN git config --global user.name "Meitu Robot"

# ------------------------------------------------------
# --- Android Debug Keystore
#RUN mkdir -p /root/.android
#COPY ./android/debug.keystore /root/.android/debug.keystore

# Dependencies to execute Android builds
RUN dpkg --add-architecture i386
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && apt-get install -y --no-install-recommends \
    libc6:i386 \
    libgcc1:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libz1:i386

## Open JDK
#RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && apt-get install -y openjdk-8-jdk
## Oracle JDK
RUN add-apt-repository -y ppa:webupd8team/java && apt-get update -qq
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && apt-get install -y --no-install-recommends \
    oracle-java8-installer \
    oracle-java8-set-default

# Install Git-lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install git-lfs
RUN git lfs install

# Cleanup
RUN apt-get clean -y && apt-get autoremove -y
RUN rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

# Go to workspace
RUN mkdir -p /var/workspace
WORKDIR /var/workspace