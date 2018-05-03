FROM lucor/bats:latest@sha256:88cf23ca5cd5451d9a88967fd17d4b2fb35b37c5662d2ed4b59fc4039aad2f0d

ENV LIBS_BATS_MOCK_VERSION "1.1.0"

RUN mkdir -p /usr/local/lib/bats/bats-mock \
    && curl -sSL https://github.com/lox/bats-mock/archive/master.tar.gz -o /tmp/bats-mock.tgz \
    && tar -zxf /tmp/bats-mock.tgz -C /usr/local/lib/bats/bats-mock --strip 1 \
    && printf 'source "%s"\n' "/usr/local/lib/bats/bats-mock/stub.bash" >> /usr/local/lib/bats/load.bash \
    && rm -rf /tmp/bats-mock.tgz

RUN apk --no-cache add ncurses

# Expose BATS_PATH so people can easily use load.bash
ENV BATS_PATH=/usr/local/lib/bats

WORKDIR /plugin
CMD ["bats", "tests/"]
