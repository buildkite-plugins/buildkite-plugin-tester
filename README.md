# Buildkite Plugin Tester ![Build status](https://badge.buildkite.com/7b010199d2978561ef5f70cf13b2933455f44c2ea56dd7f385.svg?branch=master)

A base [Docker](https://www.docker.com/) image for testing [Buildkite plugins](https://buildkite.com/docs/agent/v3/plugins) with BATS. It includes:

* [bats](https://github.com/sstephenson/bats)
* [bats-assert](https://github.com/ztombol/bats-assert)
* [bats-mock](https://github.com/lox/bats-mock)

Your plugin’s code is expected to be mounted to `/plugin`, and by default the image will run the command `bats tests/`.

## Usage

For example, say your plugin had a command hook that called `git log`. To test this, you'd create the following test in `tests/command.bats`:

```bash
#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

# Uncomment to enable stub debugging
# export GIT_STUB_DEBUG=/dev/tty

@test "calls git log" {
  stub git "log : echo git log output"
  
  run $PWD/hooks/command
  
  assert_output --partial "git log output"
  assert_success
  unstub git
}
```

And then add the following `docker-compose.yml` file to your plugin:

```yml
version: '3.4'
services:
  tests:
    image: buildkite/plugin-tester
    volumes:
      - ".:/plugin"
```

Now you can run your tests locally:

```bash
docker-compose run --rm tests
```

To set up it up in Buildkite, create a `.buildkite/pipeline.yml` file that uses the [docker-compose Buildkite Plugin](https://github.com/buildkite-plugins/docker-compose-buildkite-plugin), for example:

```yml
steps:
  - plugins:
      docker-compose#x.y.z:
        run: tests
```

## Developing

To test plugin-tester itself, use the following command:

```bash
docker-compose run --rm tests
```

## License

MIT (see [LICENSE](LICENSE))