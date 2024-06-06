FROM ubuntu:22.04
VOLUME ["/mnt/soulmask/server"]

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt update -y && \
  apt-get upgrade -y && \
  apt-get install -y  apt-utils && \
  apt-get install -y  software-properties-common \
  tzdata && \
  add-apt-repository multiverse && \
  dpkg --add-architecture i386 && \
  apt update -y && \
  apt-get upgrade -y
RUN useradd -m steam && cd /home/steam && \
  echo steam steam/question select "I AGREE" | debconf-set-selections && \
  echo steam steam/license note '' | debconf-set-selections && \
  apt purge steam steamcmd && \
  apt install -y gdebi-core  \
  libgl1-mesa-glx:i386 \
  wget && \
  apt install -y steam \
  steamcmd && \
  ln -s /usr/games/steamcmd /usr/bin/steamcmd
RUN rm -rf /var/lib/apt/lists/* && \
  apt clean && \
  apt autoremove -y

# RUN groupadd -g 1000 appuser
# RUN useradd -u 1000 -g appuser -s /bin/sh -m appuser
USER 1000:1000

WORKDIR "/mnt/soulmask/server"
CMD ["./StartServer.sh"]
