# Pumatra = Puma + Sinatra

Source: https://gist.github.com/ctalkington/4448153

## Install

bundle install
mkdir -p tmp/puma tmp/uploads

## Start Sinatra app
bundle exec puma --config puma.rb

## Start nginx

```bash
$ nginx -c $(pwd)/nginx.conf
```

For fast iteration, watch the config and reload nginx on change:

```bash
$ fswatch nginx.conf | xargs -I {} nginx -s reload
```

## Post a file

curl -X PUT -H "Content-Type:application/octet-stream" --data-binary @nginx.conf http://localhost:51880/droplets/a5bd0f13-49ac-49bc-8d35-6e02d9a1fba7/a5bd0f13-49ac-49bc-8d35-6e02d9a1fba7


## regexp

`~/droplets/(.+)\/(.+)`  
test string
 ```
 localhost:8080/droplets/7c82a535-aa67-4592-89c9-4a9507125cd7/7c82a535-aa67-4592-89c9-4a9507125cd7
 ```

`/droplets/((?!\/).)*$`  
test string
 ```
 localhost:8080/droplets/7c82a535-aa67-4592-89c9-4a9507125cd7
 ```
 verifed with https://regex101.com/r/NsDEJP/1
