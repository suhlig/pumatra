# Pumatra = Puma + Sinatra

Source: https://gist.github.com/ctalkington/4448153

## Install

```bash
bundle install
mkdir -p tmp/puma tmp/uploads tmp/store
```

## Start Sinatra app

```bash
bundle exec puma --config puma.rb
```

## Start nginx

```bash
$ nginx -p $PWD -c nginx.conf
```

`-p` sets the prefix path, which will be used in `nginx.conf` when evaluating relative paths. See [this SO article](https://stackoverflow.com/a/25486871/3212907) for details.

## Upload a file (plain HTTP PUT)

```bash
curl -X PUT -H "Content-Type:application/octet-stream" --data-binary README.markdown "http://localhost/droplets/550b1d35946db2844bc30ed343599ca573fb9058f3d5c33d777822657c3f51b3"
```

# Development

For fast iteration, watch the nginx config and reload nginx on change:

```bash
$ fswatch nginx.conf | xargs -I {} nginx -s reload
```

  This assumes that nginx was already running (see above).

Rerun does the reloading for Ruby files:

```bash
$ rerun -- bundle exec puma --config puma.rb
```

The `.tmuxinator.yml` file starts all of these commands in a single tmux window.
