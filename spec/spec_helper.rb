# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, '..', 'lib')

ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'pry'
require 'pry-byebug'

RSpec.configure do |conf|
end
