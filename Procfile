web: nginx -p $PWD -c nginx.conf
app: bundle exec puma
worker: bundle exec faktory-worker -r ./lib/pumatra/blobstore_uploader.rb
