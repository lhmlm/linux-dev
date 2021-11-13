# To build:
#    docker build -t linux-sdk:base .
#
# docker 教程: https://yeasy.gitbooks.io/docker_practice/content/
#           or https://docker_practice.gitee.io/
#

FROM ubuntu:18.04

# 定义国内镜像源
# 清华源
ENV SOURCE_LIST tsinghua.sources.18.04.list

# 定义工作目录
ENV WORK_PATH /workspace
# 创建工作目录
RUN mkdir -p $WORK_PATH


# 设置静默安装
ENV DEBIAN_FRONTEND noninteractive

# 更换国内镜像源
COPY $SOURCE_LIST $WORK_PATH

# 用户名
ENV DOCKER_USER thead

RUN chmod 1777 /tmp

# install system dependencies
RUN cd $WORK_PATH \
 && mv /etc/apt/sources.list /etc/apt/sources.list.bak \
 && mv $SOURCE_LIST /etc/apt/sources.list \
 && apt-get update && apt-get upgrade -y \
 && apt-get install -y --assume-yes --no-install-recommends \
    apt-utils \
 && apt-get install -y --assume-yes --no-install-recommends \
# common
    automake \
    autotools-dev \
    axel \
    bash \
    bash-completion \
    bc \
    bison \
    build-essential \
    busybox \
    ccache \
    chrpath \
    cpio \
    curl \
    debianutils \
    device-tree-compiler \
    diffstat \
    exuberant-ctags \
    fakeroot \
    file \
    flex \
    g++ \
    g++-multilib \
    gawk \
    gcc \
    gcc-multilib \
    git \
    gnupg \
    gperf \
    iputils-ping \
    less \
    libglib2.0-0 \
    libncurses-dev \
    libncurses5-dev \
    libssl-dev \
    locales \
    lsb-release \
    netcat-openbsd \
    nfs-common \
    openssh-server \
    pkg-config \
    procps \
    pv \
    python-pip \
    python3-pip \
    rsync \
    scons \
    socat \
    sshfs \
    sudo \
    texinfo \
    tig \
    tmux \
    tree \
    tzdata \
    unzip \
    vim \
    wget \
    x11-apps \
    xz-utils \
    zip \
    zlib1g-dev \
    zsh \
# voice SDK
    libevent-dev \
    libgnutls-dane0 \
    libgnutls-openssl27 \
    libgnutls28-dev \
    libgnutlsxx28 \
    libidn2-dev \
    libjsoncpp-dev \
    liblog4cpp5-dev \
    libopus-dev \
    libunistring-dev \
    libz-dev \
    nettle-dev \
# android
    lib32ncurses5-dev \
    lib32z-dev \
    libaio-dev \
    libattr1-dev \
    libbluetooth-dev \
    libbrlapi-dev \
    libc6-dev-i386 \
    libcap-dev \
    libgl1-mesa-dev \
    libglib2.0-dev \
    liblzo2-dev \
    libnuma-dev \
    libpixman-1-dev \
    libsnappy-dev \
    libssl-dev \
    libvdeplug-dev \
    libx11-dev \
    libxml2-utils \
    openjdk-8-jdk \
    x11proto-core-dev \
    xsltproc \
# other
    libclang-dev \
 && apt-get clean \
 && chmod 4755 /usr/bin/sudo \
 && cp /etc/ssh/ssh_config /etc/ssh/ssh_config.bak \
 && sed -i 's@^#   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc@    Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc@g' /etc/ssh/ssh_config \
 && rm -rf /var/lib/apt/lists/*

# 设置语言
RUN cp /etc/locale.gen /etc/locale.gen.bak \
 && sed -i 's@^# en_US.UTF-8 UTF-8@  en_US.UTF-8 UTF-8@g' /etc/locale.gen \
 && sed -i 's@^# zh_CN.UTF-8 UTF-8@  zh_CN.UTF-8 UTF-8@g' /etc/locale.gen \
 && locale-gen

# 设置 python
RUN python3 -m pip install -U pip -i https://pypi.tuna.tsinghua.edu.cn/simple \
 && pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
 && python  -m pip install setuptools \
 && python  -m pip install clang

# 安装 repo
RUN cd /usr/local/bin \
 && axel -n 4 https://mirrors.tuna.tsinghua.edu.cn/git/git-repo -o repo \
 && chmod +x repo

# install cmake 3.5
RUN cd $WORK_PATH \
 && axel -n 8 https://cmake.org/files/v3.5/cmake-3.5.1.tar.gz \
 && tar xf cmake-3.5.1.tar.gz \
 && cd cmake-3.5.1 \
 && ./configure \
 && make -j16 \
 && make install

# install npm
RUN cd $WORK_PATH \
 && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
 && apt install -y nodejs yarn \
 && npm install aiot-vue-cli -g

# 定义环境变量
COPY base-set-env.sh /etc/profile.d/base-set-env.sh

EXPOSE 22

RUN useradd -U -m -u 5000 -s /bin/bash -p "$(openssl passwd -1 123)" $DOCKER_USER \
 && usermod -aG sudo $DOCKER_USER \
 && mkdir -p /home/$DOCKER_USER/.ssh \
 && chown $DOCKER_USER:$DOCKER_USER /home/$DOCKER_USER/.ssh \
 && chmod 700 /home/$DOCKER_USER/.ssh


# do ENV clean
RUN rm -rf $WORK_PATH
ENV DEBIAN_FRONTEND ""
ENV new_UID ""
ENV new_GID ""

USER $DOCKER_USER
CMD /bin/bash
