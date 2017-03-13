FROM lawngnome/ubuntu:16.10

# Install the build dependencies: alpine version
# RUN apk add --update \
#         build-base \
#     && rm -rf /var/cache/apk/*

# add codebase
ADD . /usr/share/src/pigpio

# Install dependencies and build: ubuntu version
RUN buildDeps='build-essential' \
    && set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && cd /usr/share/src/pigpio \
    && make -C /usr/share/src/pigpio -j2 install \
    && rm -rf /usr/share/src/pigpio \
    && apt-get purge -y --auto-remove $buildDeps

# Default is to run the daemon
ARG DEFAULT_LISTEN_PORT
ENV LISTEN_PORT ${DEFAULT_LISTEN_PORT:-8364}

ARG DEFAULT_BUFFER_SIZE_MS
ENV BUFFER_SIZE_MS ${DEFAULT_BUFFER_SIZE_MS:-200}

ARG DEFAULT_SAMPLE_INTERVAL_uS
ENV SAMPLE_INTERVAL_uS ${DEFAULT_SAMPLE_INTERVAL_uS:-2}

CMD ['/usr/local/bin/pigpiod', \
    '-s', '$SAMPLE_INTERVAL_uS', \
    '-b', '$BUFFER_SIZE_MS', \
    '-p', '$LISTEN_PORT' ]
