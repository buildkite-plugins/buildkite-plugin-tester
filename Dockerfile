FROM bats/bats:1.11.0-no-faccessat2@sha256:4d5765d3eea98ecff9e2420ca6ca648539388b825615f994cc3544beb0cbc4f1

RUN apk --no-cache add ncurses curl jq

# Expose BATS_LIB_PATH so people can easily use load.bash
ENV BATS_PLUGIN_PATH=/usr/lib/bats

# Install our fork of bats-mock
RUN mkdir -p "${BATS_PLUGIN_PATH}"/bats-mock \
    && curl -sSL https://github.com/buildkite-plugins/bats-mock/archive/v2.1.1.tar.gz -o /tmp/bats-mock.tgz \
    && tar -zxf /tmp/bats-mock.tgz -C "${BATS_PLUGIN_PATH}"/bats-mock --strip 1 \
    && rm -rf /tmp/bats-mock.tgz

# Provide a convenient way to load all plugins at once
RUN printf 'source "%s"\n' "${BATS_PLUGIN_PATH}/bats-assert/load.bash" >> "${BATS_PLUGIN_PATH}"/load.bash \
    && printf 'source "%s"\n' "${BATS_PLUGIN_PATH}/bats-mock/stub.bash" >> "${BATS_PLUGIN_PATH}"/load.bash \
    && printf 'source "%s"\n' "${BATS_PLUGIN_PATH}/bats-file/load.bash" >> "${BATS_PLUGIN_PATH}"/load.bash \
    && printf 'source "%s"\n' "${BATS_PLUGIN_PATH}/bats-support/load.bash" >> "${BATS_PLUGIN_PATH}"/load.bash

# Make sure /bin/bash is available, as bats/bats only has it at
# /usr/local/bin/bash and many plugin hooks (and shellscripts in general) use
# `#!/bin/bash` as their shebang
RUN if [[ -e /bin/bash ]]; then echo "/bin/bash already exists"; exit 1; else ln -s /usr/local/bin/bash /bin/bash; fi


WORKDIR /plugin

ENTRYPOINT []
CMD ["bats", "tests/"]
