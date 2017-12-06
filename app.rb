#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'fileutils'

configure {
  set :server, :puma
}

class Pumatra < Sinatra::Base
  get '/droplets/:guid' do |guid|
    unless File.exist?("tmp/store/#{guid}")
      halt 404, {'Content-Type' => 'text/plain'}, "There is no droplet with GUID #{guid}"
    end

    content_type 'application/octet-stream'
    File.read("tmp/store/#{guid}")
  end

  put '/droplets/:guid' do |guid|
    content_type 'application/json'
    uploaded_file = request.env['HTTP_DROPLET_FILE']
    FileUtils.copy(uploaded_file, "tmp/store/#{guid}")

    {
      droplet: {
        guid: guid,
        url: request.url,
        size: File.size(uploaded_file),
      }
    }.to_json
  end

  run! if app_file == $0
end
