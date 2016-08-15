# tklx/haproxy - High performance, high availability proxy
[![CircleCI](https://circleci.com/gh/tklx/haproxy.svg?style=shield)](https://circleci.com/gh/tklx/haproxy)

[HAProxy][haproxy] is free, open source software that provides a high availability load balancer and proxy server for TCP and HTTP-based applications that spreads requests across multiple servers. It is written in C and has a reputation for being fast and efficient (in terms of processor and memory usage).

## Features

- Based on the super slim [tklx/base][base] (Debian GNU/Linux).
- HAProxy installed directly from Debian.
- Uses [tini][tini] for zombie reaping and signal forwarding.

## Usage

Due to the versatility of HAProxy deployments, we recommend using the official upstream [starter guide][haproxy-guide] or [configuration][haproxy-config] and [management][haproxy-management] guides and the provided [examples][haproxy-examples]. This image comes with no custom configuration nor a default set of exposed ports.

While many examples show ``daemon`` in the ``global`` section of the config file, this will cause the Docker container to fail on launch and should not be enabled.

### Running the container with a custom configuration

```console
$ docker run -d --name some-haproxy -v /path/to/haproxy.cfg:/etc/haproxy/haproxy.cfg:ro tklx/haproxy
```

#### Checking config file syntax

```console
$ docker run -it --rm --name some-haproxy -v /path/to/haproxy.cfg:/etc/haproxy/haproxy.cfg:ro tklx/haproxy -c -f /etc/haproxy/haproxy.cfg
```

### Exposing the port(s)

#### User-chosen

```console
$ docker run -d -p 8080:80 -p 4343:443 tklx/haproxy
```

#### Randomly chosen by Docker

```console
$ docker run --name some-haproxy -dP tklx/haproxy
$ docker port some-haproxy
```

### Reloading configuration seamlessly

If you have edited your haproxy.cfg file, you can use haproxy's graceful reload feature by sending a SIGHUP to the container:

```console
$ docker kill -s HUP some-haproxy
```

The entrypoint script in the image replaces the ``haproxy`` command with ``haproxy-systemd-wrapper`` from HAProxy upstream, which takes care of signal handling to do the graceful reload. Under the hood this uses the -sf option of haproxy so "there are two small windows of a few milliseconds each where it is possible that a few connection failures will be noticed during high loads" (see [Stopping and restarting HAProxy][haproxy-management]).

## Automated builds

The [Docker image](https://hub.docker.com/r/tklx/mongodb/) is built, tested and pushed by [CircleCI](https://circleci.com/gh/tklx/mongodb) from source hosted on [GitHub](https://github.com/tklx/mongodb).

* Tag: ``x.y.z`` refers to a [release](https://github.com/tklx/mongodb/releases) (recommended).
* Tag: ``latest`` refers to the master branch.

## Status

Currently on major version zero (0.y.z). Per [Semantic Versioning][semver],
major version zero is for initial development, and should not be considered
stable. Anything may change at any time.

## Issue Tracker

TKLX uses a central [issue tracker][tracker] on GitHub for reporting and
tracking of bugs, issues and feature requests.

[haproxy]: http://www.haproxy.org/
[haproxy-guide]: http://cbonte.github.io/haproxy-dconv/1.6/intro.html
[haproxy-config]: http://cbonte.github.io/haproxy-dconv/1.6/configuration.html
[haproxy-management]: http://cbonte.github.io/haproxy-dconv/1.6/management.html
[base]: https://github.com/tklx/base
[tini]: https://github.com/krallin/tini
[semver]: http://semver.org/
[tracker]: https://github.com/tklx/tracker/issues
