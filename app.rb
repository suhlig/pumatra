#!/usr/bin/env ruby

require 'sinatra'

configure {
  set :server, :puma
}

class Pumatra < Sinatra::Base
  get '/' do
    'Hello'
  end

  post '/droplets' do
    File.read(request.env['HTTP_DROPLET_FILE'])
  end

  run! if app_file == $0
end
