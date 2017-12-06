# frozen_string_literal: true

require 'fileutils'

module Pumatra
  class Blobstore
    def initialize(root)
      @root = root
    end

    def exist?(guid)
      File.exist?("#{@root}/#{guid}")
    end

    def size(guid)
      File.size("#{@root}/#{guid}")
    end

    def get(guid)
      File.read("#{@root}/#{guid}")
    end

    def put(guid, blob_file)
      FileUtils.copy(blob_file, "#{@root}/#{guid}")
    end
  end
end
