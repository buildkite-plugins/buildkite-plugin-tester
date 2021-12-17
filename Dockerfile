FROM bats/bats:latest@sha256:97d91ee0aa9771e696cdf44c2b1672af484fd846eaf52ba2db6061f5c78a89d5

ENV LIBS_BATS_MOCK_VERSION="1.3.0" \
    LIBS_BATS_SUPPORT_VERSION="0.3.0"

RUN apk --no-cache add ncurses curl jq

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
    && curl -sSL https://github.com/lox/bats-mock/archive/v${LIBS_BATS_MOCK_VERSION}.tar.gz -o /tmp/bats-mock.tgz \
    && tar -zxf /tmp/bats-mock.tgz -C /usr/local/lib/bats/bats-mock --strip 1 \
    && printf 'source "%s"\n' "/usr/local/lib/bats/bats-mock/stub.bash" >> /usr/local/lib/bats/load.bash \
    && rm -rf /tmp/bats-mock.tgz

# Make sure /bin/bash is available, as bats/bats only has it at
# /usr/local/bin/bash and many plugin hooks (and shellscripts in general) use
# `#!/bin/bash` as their shebang
RUN if [[ -e /bin/bash ]]; then echo "/bin/bash already exists"; exit 1; else ln -s /usr/local/bin/bash /bin/bash; fi

# Expose BATS_PATH so people can easily use load.bash
ENV BATS_PATH=/usr/local/lib/bats

WORKDIR /plugin

ENTRYPOINT []
CMD ["bats", "tests/"]
