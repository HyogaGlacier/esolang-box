FROM ubuntu:16.04
MAINTAINER Koki Takahashi <hakatasiloving@gmail.com>

# Install add-apt-repository
RUN apt-get -y update
RUN apt-get install -y software-properties-common

RUN add-apt-repository -y ppa:brightbox/ruby-ng-experimental

# Install apt packages
RUN apt-get -y update
RUN apt-get install -y git build-essential sudo ruby2.4 curl
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add user 'esolang'
RUN groupadd -g 1000 esolang \
    && useradd -g esolang -G sudo -m -s /bin/bash esolang \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy assets
COPY assets /home/esolang/assets
RUN chown esolang:esolang /home/esolang/assets -R && chmod 744 /home/esolang/assets && chmod 644 /home/esolang/assets/*

COPY bin /home/esolang/bin
RUN chown esolang:esolang /home/esolang/bin -R && chmod 744 /home/esolang/bin -R

# Enter into esolang user
USER esolang

# Export path
ENV PATH $PATH:/home/esolang/bin

# Install hexagony
RUN git clone --depth 1 https://github.com/m-ender/hexagony.git ~/hexagony

# Install unlambda
RUN curl ftp://ftp.madore.org/pub/madore/unlambda/unlambda-2.0.0.tar.gz -o /tmp/unlambda.tar.gz \
    && tar xzf /tmp/unlambda.tar.gz -C /tmp \
    && gcc -O2 -Wall -o ~/bin/unlambda-exec /tmp/unlambda-2.0.0/c-refcnt/unlambda.c

# Install snowman
RUN git clone --depth 1 https://github.com/KeyboardFire/snowman-lang.git ~/snowman \
    && cd ~/snowman/lib \
    && make

# Clean up /tmp
RUN sudo rm -rf /tmp/*

WORKDIR /home/esolang
