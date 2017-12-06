# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative 'blobstore'

configure {
  set :server, :puma
}

module Pumatra
  class App < Sinatra::Base
    configure do
      set :blobstore, Blobstore.new('tmp/store')
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
      settings.blobstore.put(guid, uploaded_file)

      {
        droplet: {
          guid: guid,
          url: request.url,
          size: settings.blobstore.size(guid),
        }
      }.to_json
    end

    run! if app_file == $PROGRAM_NAME
  end
end
