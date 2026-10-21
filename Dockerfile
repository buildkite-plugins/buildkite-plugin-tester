FROM bats/bats:1.14.0@sha256:5322b877351fda0cc435de8c6116de7d0a2ec79d7c680132a0ef329a633bc66f

# Refresh system trust before downloading dependencies and for HTTPS in user tests.
# These minimum versions include the eMudhra CA compromise remediation.
RUN apk --no-cache add --upgrade \
    'ca-certificates>=20261020-r0' \
    'ca-certificates-bundle>=20261020-r0' \
    ncurses curl jq

# Expose BATS_LIB_PATH so people can easily use load.bash
ENV BATS_PLUGIN_PATH=/usr/lib/bats

# Install our fork of bats-mock
RUN mkdir -p "${BATS_PLUGIN_PATH}"/bats-mock \
    && curl -fsSL https://github.com/buildkite-plugins/bats-mock/archive/v2.2.0.tar.gz -o /tmp/bats-mock.tgz \
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
