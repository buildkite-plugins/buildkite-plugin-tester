FROM bats/bats:1.12.0-no-faccessat2@sha256:8d8b6712d46330d22f43a40ff62e190ce5e18611e8489b335284b1d94fd62415

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

WORKDIR /plugin

ENTRYPOINT []
CMD ["bats", "tests/"]
