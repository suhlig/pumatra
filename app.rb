#!/usr/bin/env ruby

require 'sinatra'

configure {
  set :server, :puma
}

class Pumatra < Sinatra::Base
  get '/' do
    'Hello'
  end

  put '/droplets/:guid' do |guid|
    File.read(request.env['HTTP_DROPLET_FILE'])
  end

  put %r{^/droplets/(.*/.*)} do |path|
    "TODO do something with #{path}; FOO is #{request.env['FOO'].inspect}\n"
  end

  run! if app_file == $0
end
