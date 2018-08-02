FROM bats/bats:latest@sha256:e7a5e065814b784c51219ee460d9901d9d44cd642dfc2dc3a3006e52334e8705

ENV LIBS_BATS_MOCK_VERSION="1.1.0" \
    LIBS_BATS_SUPPORT_VERSION="0.3.0"

RUN apk --no-cache add ncurses curl

# Install bats-support
RUN mkdir -p /usr/local/lib/bats/bats-support \
    && curl -sSL https://github.com/ztombol/bats-support/archive/v0.3.0.tar.gz -o /tmp/bats-support.tgz \
    && tar -zxf /tmp/bats-support.tgz -C /usr/local/lib/bats/bats-support --strip 1 \
    && printf 'source "%s"\n' "/usr/local/lib/bats/bats-support/load.bash" >> /usr/local/lib/bats/load.bash \
    && rm -rf /tmp/bats-support.tgz

# Install bats-assert
RUN mkdir -p /usr/local/lib/bats/bats-assert \
    && curl -sSL https://github.com/ztombol/bats-assert/archive/v0.3.0.tar.gz -o /tmp/bats-assert.tgz \
    && tar -zxf /tmp/bats-assert.tgz -C /usr/local/lib/bats/bats-assert --strip 1 \
    && printf 'source "%s"\n' "/usr/local/lib/bats/bats-assert/load.bash" >> /usr/local/lib/bats/load.bash \
    && rm -rf /tmp/bats-assert.tgz

# Install lox's fork of bats-mock
RUN mkdir -p /usr/local/lib/bats/bats-mock \
    && curl -sSL https://github.com/lox/bats-mock/archive/master.tar.gz -o /tmp/bats-mock.tgz \
    && tar -zxf /tmp/bats-mock.tgz -C /usr/local/lib/bats/bats-mock --strip 1 \
    && printf 'source "%s"\n' "/usr/local/lib/bats/bats-mock/stub.bash" >> /usr/local/lib/bats/load.bash \
    && rm -rf /tmp/bats-mock.tgz

# Expose BATS_PATH so people can easily use load.bash
ENV BATS_PATH=/usr/local/lib/bats

WORKDIR /plugin

ENTRYPOINT []
CMD ["bats", "tests/"]
