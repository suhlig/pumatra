# Pumatra = Puma + Sinatra with Background Worker

This is an nginx server that takes file uploads, stores them locally and passes the filename on to a Sinatra app, which then uploads this file to a (potentially remote) blob store. The concept is an extraction from the CloudFoundry [bits-service](https://github.com/cloudfoundry-incubator/bits-service).

The name 'pumatra' was first seen on [this gist](https://gist.github.com/ctalkington/4448153).

# Installation

```bash
gem install foreman
brew bundle
bundle install
mkdir -p tmp/puma tmp/uploads tmp/store
```

# Configuration

Faktory uses two environment variables to point to the server:

```bash
export FAKTORY_PROVIDER=FAKTORY_URL
export FAKTORY_URL=tcp://localhost:7419
```

# Running

## Start

```bash
foreman start
```

## Upload a file (plain HTTP PUT)

```bash
curl -X PUT -H "Content-Type:application/octet-stream" --data-binary README.markdown "http://localhost/droplets/550b1d35946db2844bc30ed343599ca573fb9058f3d5c33d777822657c3f51b3"
```

## Stats

```bash
pumactl --control-url unix://tmp/puma/ctl.sock --control-token s3cret stats
```

# Development

For fast iteration, watch the nginx config and reload nginx on change:

```bash
$ fswatch nginx.conf | xargs -I {} nginx -s reload
```

  This assumes that nginx was already running (see above).

Rerun does the reloading for Ruby files (but not when specs have changed):

```bash
$ rerun -i 'spec/*' foreman start
```
