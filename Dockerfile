FROM lawngnome/ubuntu:16.10

# Install the build dependencies: alpine version
# RUN apk add --update \
#         build-base \
#     && rm -rf /var/cache/apk/*

# Install the build dependencies: ubuntu version
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

# Actually build pigpiod
ADD . /usr/share/src/pigpio
RUN make -C /usr/share/src/pigpio -j2 install

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
