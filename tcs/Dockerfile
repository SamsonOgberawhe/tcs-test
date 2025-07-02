FROM --platform=linux/amd64 ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tzdata \
    libaio1 \
    numactl \
    dmidecode \
    openjdk-8-jdk \
    openjdk-8-jre \
    sudo \
    wget \
    systemd \
    curl \
    jq \
    cron \
    vim \
    iputils-ping \
    traceroute

ENV TZ=Africa/Kampala
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN dpkg-reconfigure --frontend noninteractive tzdata

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV JRE_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

ADD scripts /usr/local/bin

RUN mkdir /root/config
RUN mkdir -p /var/log/efris
VOLUME /root/config

COPY config/efris_server.tar.gz /root/config/

# Setup cronjob to refresh encryption key periodically
RUN echo "0 */1 * * * /usr/local/bin/refresh-encryption-key.sh 2>&1 >> /var/log/efris/refresh_encryption_key.log" >> /tmp/cronjobs && \
     crontab /tmp/cronjobs && \
     rm /tmp/cronjobs

CMD ["start.sh"]
