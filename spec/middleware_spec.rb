require 'spec_helper'

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
  end

  describe 'unrecognized path' do
    it 'outputs app content' do
      response = server.get('/foo')
      expect(response.body).to eq 'Foo'
    end
  end

  describe '/build_info' do
    before do
      @response = server.get('/build_info')
    end

    it 'outputs build info' do
      expect(@response.body).to_not eq 'Foo'
      expect(@response.body).to eq "{\n  \"git\": \"git revision\",\n  \"gems\": \"bundle show\"\n}"
    end

    it 'returns HTTP status 200' do
      expect(@response.status). to eq 200
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
        @response = server.get('/build_info')
        expect(@response.body).to eq "{\n  \"git\": \"git revision\",\n  \"./spec/support/platform_version\": \"1.2.3\\n\",\n  \"gems\": \"bundle show\"\n}"
      end
    end
  end

  describe 'Rails::Info' do
    before do
      @response = server.get('/build_info')
    end

    context 'when rails is not defined' do
      it 'does not output rails info' do
        expect(@response.body).to_not include "Rails::Info"
      end
    end

    context 'when rails is defined' do
      xit 'outputs rails info' do
        rails = double('Rails', :env => :production)
        Object.send(:const_set, :Rails, rails)
        expect(Rails).to receive(:env).and_return('production')
        expect(@response.body).to include "Rails::Info"
      end
    end
  end
end
