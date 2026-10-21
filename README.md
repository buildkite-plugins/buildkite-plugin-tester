# Buildkite Plugin Tester [![Build status](https://badge.buildkite.com/f6ce96d897af406221809efe925c0808cc49cdcf5b91771ce0.svg?branch=main)](https://buildkite.com/buildkite/plugin-tester)

A base [Docker](https://www.docker.com/) image for testing [Buildkite plugins](https://buildkite.com/docs/agent/v3/plugins) with BATS. It includes:

* [bats-core](https://github.com/bats-core/bats-core)
* [bats-support](https://github.com/bats-core/bats-support)
* [bats-assert](https://github.com/bats-core/bats-assert)
* [bats-mock](https://github.com/buildkite-plugins/bats-mock)
* [bats-file](https://github.com/bats-core/bats-file)

Your plugin’s code is expected to be mounted to `/plugin`, and by default the image will run the command `bats tests/`.

## Usage

For example, say you had a plugin called `git-logger`, which took a `commit` option, and called `git log` via a command hook:

```yml
steps:
  - plugins:
      - foo/git-logger#v1.0.0:
          commit: "abc123"
```

To test this, you'd add the following `docker-compose.yml` file:

```yml
version: '3.7'
services:
  tests:
    image: buildkite/plugin-tester:v4.1.1
    volumes:
      - ".:/plugin"
```

And you'd create the following test in `tests/command.bats`:

```bash
#!/usr/bin/env bats

setup() {
  load "$BATS_PLUGIN_PATH/load.bash"

  # Uncomment to enable stub debugging
  # export GIT_STUB_DEBUG=/dev/tty
}

@test "calls git log" {
  export BUILDKITE_PLUGIN_GIT_LOGGER_COMMIT="abc123"

  stub git "log abc123 : echo git log output"

  run $PWD/hooks/command

  assert_output --partial "git log output"
  assert_success
  unstub git
}
```

Now you can run your tests locally:

```bash
docker-compose run --rm tests
```

To set up it up in Buildkite, create a `.buildkite/pipeline.yml` file that uses the [docker-compose Buildkite Plugin](https://github.com/buildkite-plugins/docker-compose-buildkite-plugin) to run that same command on CI, for example:

```yml
steps:
  - plugins:
      - docker-compose#x.y.z:
          run: tests
```

## Container runtime compatibility

The image now uses the standard Bats 1.14.0 image on Alpine 3.24, replacing the
`no-faccessat2` variant on Alpine 3.12. Bats remains at the same version, but Bash
and other system packages are newer. The system certificate store is updated to
include the eMudhra CA compromise remediation before downloading dependencies.

The legacy workaround for old container runtimes has been removed. Use a
maintained Docker/container runtime and libseccomp configuration. Older runtimes
that incorrectly block the `faccessat2` system call can cause Bats to report
`BATS_TMPDIR (/tmp) is not writable`, even when directory permissions are correct.
Upgrade the host runtime rather than disabling seccomp or using privileged mode.
For Docker-in-Docker, check both the outer and inner runtimes.

## Developing

To test plugin-tester itself, use the following command:

```bash
docker-compose run --rm tests
```

## Releasing

1. Create a [new GitHub Release](https://github.com/buildkite-plugins/buildkite-plugin-tester/releases/new). Docker Hub images are automatically pushed when the new tag is created.
2. Update the [README.md](https://github.com/buildkite-plugins/buildkite-plugin-tester/edit/main/README.md) example line’s version number (`image: buildkite/plugin-tester#vX.Y.Z`)

## License

MIT (see [LICENSE](LICENSE))
