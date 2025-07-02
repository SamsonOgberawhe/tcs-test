FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Create app directory
WORKDIR /TaxControlService

# Copy and extract your tar.gz
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    libaio1 \
    tar \
    net-tools \
    procps \
    lsb-core \
    iputils-ping \
    sudo \
    libnuma1\
    && apt-get clean

ENV TZ=Africa/Kampala
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN dpkg-reconfigure --frontend noninteractive tzdata

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV JRE_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre


RUN echo "JAVA_HOME is set to JAVA HOME"

#make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

ADD scripts /usr/local/bin

RUN mkdir /root/config
RUN mkdir -p /var/log/efris
VOLUME /root/config

COPY efris_server.tar.gz /root/config/
RUN echo "ABOUT TO RUN START.SH"
# Setup cronjob to refresh encryption key periodically
RUN echo "0 */1 * * * /usr/local/bin/refresh-encryption-key.sh 2>&1 >> /var/log/efris/refresh_encryption_key.log" >> /tmp/cronjobs && \
     crontab /tmp/cronjobs && \
     rm /tmp/cronjobs

EXPOSE 9880

CMD ["/usr/local/bin/start.sh"]
