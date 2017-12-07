# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative 'blobstore'
require_relative 'blobstore_uploader'

configure {
  set :server, :puma
}

module Pumatra
  class App < Sinatra::Base
    configure do
      set :blobstore_root, 'tmp/store'
      set :blobstore, Blobstore.new(settings.blobstore_root)
    end

    head '/droplets/:guid' do |guid|
      settings.blobstore.exist?(guid) ? 200 : 404
    end

    get '/droplets/:guid' do |guid|
      unless settings.blobstore.exist?(guid)
        halt 404, { 'Content-Type' => 'text/plain' }, "There is no droplet with GUID #{guid}"
      end

      content_type 'application/octet-stream'
      settings.blobstore.get(guid)
    end

    put '/droplets/:guid' do |guid|
      content_type 'application/json'
      uploaded_file = request.env['HTTP_DROPLET_FILE']

      begin
        BlobstoreUploader.perform_async(settings.blobstore_root, guid, uploaded_file)
      rescue Errno::ECONNREFUSED
        halt 500, { 'Content-Type' => 'text/plain' }, "Could not enqueue blobstore upload job because it could not connect to Faktory"
      end

      {
        droplet: {
          guid: guid,
          url: request.url,
        }
      }.to_json
    end

    run! if app_file == $PROGRAM_NAME
  end
end
