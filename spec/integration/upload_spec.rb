# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'
require 'restclient'
require 'pathname'

describe 'File Upload' do
  let(:digest) { SecureRandom.uuid }
  let(:droplet_content) { SecureRandom.bytes(128) }
  let(:endpoint) { "http://localhost:51880/droplets/#{digest}" }
  let(:stored_file) { Pathname.new("tmp/store/#{digest}") }
  let(:upload_dir) { Pathname.new('tmp/uploads') }

  after do
    stored_file.unlink if stored_file.exist?
  end

  it 'stores an uploaded droplet' do
    RestClient.put(
      endpoint,
      droplet_content,
      content_type: 'application/octet-stream'
    )

    eventually(10) do
      expect(stored_file).to exist
    end
  end

  it 'removes the temporary file after the job has completed' do
    expect(upload_dir.children).to be_empty

    RestClient.put(
      endpoint,
      droplet_content,
      content_type: 'application/octet-stream'
    )

    eventually(10) do
      expect(upload_dir.children).to be_empty
    end
  end

  it 'cannot download a non-existing droplet' do
    expect { RestClient.get(endpoint) }.to raise_error RestClient::NotFound
  end

  it 'returns 404 on a HEAD request to a non-existing droplet' do
    expect { RestClient.head(endpoint) }.to raise_error RestClient::NotFound
  end

  context 'a droplet exists' do
    before do
      stored_file.write(droplet_content)
    end

    it 'can check for a file' do
      response = RestClient.head(endpoint)
      expect(response.code).to eq(200)
    end

    it 'can download a file' do
      response = RestClient.get(endpoint)
      expect(response.body).to eq(droplet_content)
    end
  end

  def eventually(timeout)
    start_time = Time.now

    loop do
      begin
        yield
        break
      rescue RSpec::Expectations::ExpectationNotMetError
        elapsed_time = Time.now - start_time
        fail "Could not find #{stored_file} within #{timeout} s" if elapsed_time >= timeout
        sleep 0.1
      end
    end
  end
end
