# frozen_string_literal: true

require 'connection_pool'
require 'faktory'
require_relative 'blobstore'

module Pumatra
  class BlobstoreUploader
    include Faktory::Job
    faktory_options retry: 3

    def perform(blobstore_root, guid, uploading_file)
      puts "Uploading #{uploading_file} as #{guid} to #{blobstore_root}"
      sleep 2 # simulate expensive work
      Blobstore.new(blobstore_root).put(guid, uploading_file)
    end
  end
end
