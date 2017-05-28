# Buildkite Plugin Tester

A [Docker](https://www.docker.com/) image you can use to help test your Buildkite Plugin. It includes:

* [bats](https://github.com/sstephenson/bats)
* [bats-mock](https://github.com/jasonkarns/bats-mock)

It expects plugin code to be mounted to `/plugin`, and by default will run the command `bats tests/`.

## Usage

Add the following `docker-compose.yml` file to your plugin:

```bash
version: '2'
services:
  tests:
    image: buildkite/plugin-tester
```

Test it locally:

```bash
docker-compose run --rm tests
```

To set up CI, you can create a `.buildkite/pipeline.yml` file and use the [docker-compose Buildkite Plugin](https://github.com/buildkite-plugins/docker-compose-buildkite-plugin), for example:

```yml
steps:
  - plugin:
      docker-compose#x.y.z:
        run: tests
```

## License

MIT (see [LICENSE](LICENSE))