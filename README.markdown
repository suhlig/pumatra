# Pumatra = Puma + Sinatra with Background Worker

Source: https://gist.github.com/ctalkington/4448153

## Install

```bash
bundle install
mkdir -p tmp/puma tmp/uploads tmp/store
```

We'll also need a [Faktory installation](https://github.com/contribsys/faktory/wiki/Installation) and two environment variables to point to it, e.g. for a Faktory running in a Docker container:

```bash
export FAKTORY_PROVIDER=FAKTORY_URL
export FAKTORY_URL=tcp://$(docker-machine ip default):7419
```

## Start

```bash
foreman start
```

## Upload a file (plain HTTP PUT)

```bash
curl -X PUT -H "Content-Type:application/octet-stream" --data-binary README.markdown "http://localhost/droplets/550b1d35946db2844bc30ed343599ca573fb9058f3d5c33d777822657c3f51b3"
```

# Deployment

`gem install foreman` and then run the following command in the project's directory:

```bash
foreman start
```

# Development

For fast iteration, watch the nginx config and reload nginx on change:

```bash
$ fswatch nginx.conf | xargs -I {} nginx -s reload
```

  This assumes that nginx was already running (see above).

Rerun does the reloading for Ruby files:

```bash
$ rerun foreman start
```
