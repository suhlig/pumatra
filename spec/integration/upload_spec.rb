# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'
require 'restclient'
require 'pathname'

describe 'Pumatra' do
  let(:digest) { SecureRandom.uuid }
  let(:droplet_content) { SecureRandom.bytes(128) }
  let(:endpoint) { "http://localhost:51880/droplets/#{digest}" }

  after do
    stored_file.unlink if stored_file.exist?
  end

  it 'can upload a droplet' do
    RestClient.put(
      endpoint,
      droplet_content,
      content_type: 'application/octet-stream'
    )

    expect(stored_file).to exist
  end

  it 'cannot download a non-existing guid' do
    expect { RestClient.get(endpoint) }.to raise_error RestClient::NotFound
  end

  it 'returns 404 on a HEAD request to a non-existing guid' do
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

  def stored_file
    Pathname.new("tmp/store/#{digest}")
  end
end
