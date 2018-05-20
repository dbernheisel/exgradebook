FROM ubuntu:18.04
MAINTAINER David Bernheisel <david@bernheisel.com>

WORKDIR /app

# Set locale
RUN apt-get update && apt-get install -y curl locales
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# Language dependencies
RUN apt-get update
RUN apt-get install -y \
  aptitude \
  git wget \
  build-essential automake autoconf m4 \
  libreadline-dev libyaml-dev libncurses5-dev ca-certificates libssh-dev libxslt-dev xsltproc libxml2-utils libffi-dev libtool unzip \
  default-jdk unixodbc-dev fop \
  libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev

# Add precompiled erlang if needed
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
  dpkg -i erlang-solutions_1.0_all.deb && \
  apt-get update

## Install asdf
RUN git clone https://github.com/asdf-vm/asdf.git /asdf
RUN echo '. /asdf/asdf.sh' >> /etc/bash.bashrc
ENV PATH /asdf/bin:/asdf/shims:$PATH
ENV NODEJS_CHECK_SIGNATURES=no
RUN asdf plugin-add erlang && \
    asdf plugin-add elixir && \
    asdf plugin-add nodejs

# Because asdf installs and builds erlang from source, it's slow.
# we can speed things up by installing erlang before asdf tries
# to install, and skipping if it's already installed.
# Drawback: You have to manage the erlang version here in addition
# to your dev environment (asdf)

RUN apt-get install -y esl-erlang=1:20.1

# Application dependencies
RUN apt-get install -y \
  python

# Build app
COPY . /app
RUN ./bin/setup
