FROM bats/bats:1.9.0-no-faccessat2@sha256:ebe8ebd3138b293af3b3d648ad703951cf22dbdd7ebc0cf80022f5140a65177d

RUN apk --no-cache add ncurses curl jq

# Install our fork of bats-mock
RUN mkdir -p /usr/local/lib/bats/bats-mock \
    && curl -sSL https://github.com/buildkite-plugins/bats-mock/archive/v2.1.0.tar.gz -o /tmp/bats-mock.tgz \
    && tar -zxf /tmp/bats-mock.tgz -C /usr/local/lib/bats/bats-mock --strip 1 \
    && printf 'source "%s"\n' "/usr/local/lib/bats/bats-mock/stub.bash" >> /usr/local/lib/bats/load.bash \
    && rm -rf /tmp/bats-mock.tgz

# Make sure /bin/bash is available, as bats/bats only has it at
# /usr/local/bin/bash and many plugin hooks (and shellscripts in general) use
# `#!/bin/bash` as their shebang
RUN if [[ -e /bin/bash ]]; then echo "/bin/bash already exists"; exit 1; else ln -s /usr/local/bin/bash /bin/bash; fi

# Expose BATS_LIB_PATH so people can easily use load.bash
ENV BATS_PLUGIN_PATH=/usr/local/lib/bats

WORKDIR /plugin

ENTRYPOINT []
CMD ["bats", "tests/"]
