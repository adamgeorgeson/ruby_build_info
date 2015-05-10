require 'spec_helper'
require 'support/info'

describe RubyBuildInfo::Middleware do
  subject{ described_class.new(app) }

  let(:app) do
    lambda do |env|
      [200, {'Content-Type' => 'text/html'}, 'Foo']
    end
  end

  let(:server){ Rack::MockRequest.new(subject) }

  before do
    allow(subject).to receive(:bundle_show).and_return('bundle show')
    allow(subject).to receive(:git_revision).and_return('git revision')
    allow(subject).to receive(:rails_defined?).and_return false
  end

  describe 'unrecognized path' do
    it 'outputs app content' do
      response = server.get('/foo')
      expect(response.body).to eq 'Foo'
    end
  end

  describe '/build_info' do
    let(:example_response) { "{\n  \"git\": \"git revision\",\n  \"gems\": \"bundle show\"\n}" }

    context 'when a token configured' do
      subject{ described_class.new(app, token: 'foo') }
      let(:server){ Rack::MockRequest.new(subject) }

      it 'outputs build info when token matches param' do
        @response = server.get('/build_info?token=foo&param2=value2')
        expect(@response.body).to_not eq 'Foo'
        expect(@response.body).to eq example_response
        expect(@response.status). to eq 200
      end

      it 'does not output build info when token does not match param' do
        @response = server.get('/build_info?param1=value1&token=bar')
        expect(@response.body).to eq 'Foo'
        expect(@response.body).to_not eq example_response
        expect(@response.status). to eq 200
      end
    end

    context 'when a token is not configured' do
      subject{ described_class.new(app) }
      let(:server){ Rack::MockRequest.new(subject) }

      before do
        @response = server.get('/build_info')
      end

      it 'outputs build info' do
        expect(@response.body).to_not eq 'Foo'
        expect(@response.body).to eq example_response
      end

      it 'returns HTTP status 200' do
        expect(@response.status). to eq 200
      end
    end
  end

  describe 'read_file_paths' do
    context 'when an invalid file path is specified' do
      subject{ described_class.new(app, file_paths: ['./foo']) }
      let(:server){ Rack::MockRequest.new(subject) }

      it 'raises an exception' do
        expect{ server.get('/build_info') }.to raise_exception
      end
    end

    context 'when file_paths is not an array' do
      subject{ described_class.new(app, file_paths: './spec/support/platform_version') }
      let(:server){ Rack::MockRequest.new(subject) }

      it 'raises an exception' do
        expect{ server.get('/build_info') }.to raise_exception
      end
    end

    context 'when a valid file path is specified' do
      subject{ described_class.new(app, file_paths: ['./spec/support/platform_version']) }
      let(:server){ Rack::MockRequest.new(subject) }

      it 'returns content of the file' do
        expected_response = "{\n  \"git\": \"git revision\",\n  \"./spec/support/platform_version\": \"1.2.3\\n\",\n  \"gems\": \"bundle show\"\n}"
        @response = server.get('/build_info')
        expect(@response.body).to eq expected_response
      end
    end
  end

  describe 'Rails::Info' do
    context 'when rails is not defined' do
      it 'does not output rails info' do
        @response = server.get('/build_info')
        expect(@response.body).to_not include "Rails::Info"
      end
    end

    context 'when rails is defined' do
      before do
      end
      it 'outputs rails info' do
        allow(subject).to receive(:rails_defined?).and_return true
        @response = server.get('/build_info')
        expect(@response.body).to include "Rails::Info"
      end
    end
  end
end
