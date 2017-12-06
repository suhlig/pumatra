# frozen_string_literal: true

require 'connection_pool'
require 'faktory'
require_relative 'blobstore'

module Pumatra
  class Worker
    include Faktory::Job

    def perform(blobstore_root, guid, uploading_file)
      puts "Uploading #{uploading_file} as #{guid} to #{blobstore_root}"
      sleep 2 # simulate expensive work
      Blobstore.new(blobstore_root).put(guid, uploading_file)
    end
  end
end
