# Pumatra = Puma + Sinatra

Source: https://gist.github.com/ctalkington/4448153

# Install

bundle install
mkdir -p tmp/puma tmp/uploads

# Start Sinatra app
bundle exec puma --config puma.rb

# Start nginx

```bash
$ nginx -c $(pwd)/nginx.conf
```

For fast iteration, watch the config and reload nginx on change:

```bash
$ fswatch nginx.conf | xargs -I {} nginx -s reload
```

# Post a file

curl -H "Content-Type:application/octet-stream" --data-binary @nginx.conf http://localhost:51880/droplets
