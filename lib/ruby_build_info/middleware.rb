module RubyBuildInfo
  class Middleware
    require 'json'

    def initialize(app, options = {})
      @app = app
      @file_paths = options[:file_paths]
      @token = options[:token]
    end

    def call(env)
      if env['PATH_INFO'] == '/build_info'
        @env = env
        return @app.call(env) unless token_valid?

        @build_info = {}
        @build_info[:git] = git_revision unless git_revision.empty?
        read_file_paths
        rails_info
        @build_info[:gems] = bundle_show
        output = JSON.pretty_generate(@build_info)
        [200, {'Content-Type' => 'application/json'}, [output]]
      else
        @app.call(env)
      end
    end

    private

    def bundle_show
      `bundle show`.gsub(/\n /, '').gsub(/\n/, '').split(' * ')
    end

    def git_revision
      `git log --pretty=format:'%ad %h %d' --abbrev-commit --date=short -1`
    end

    def read_file_paths
      if @file_paths
        @file_paths.each do |file|
          raise "File does not exist: #{file}" unless File.exist? file
          @build_info[file] = `less #{file}`
        end
      end
    end

    def params
      query_string = @env['QUERY_STRING']
      return nil if query_string.nil?
      Hash[query_string.split('&').map{ |q| q.split('=') }]
    end

    def rails_defined?
      defined? Rails
    end

    def rails_info
      if rails_defined?
        result = Rails::Info.properties
        @build_info['Rails::Info'] = Hash[result]
      end
    end

    def token_param
      params['token'] if params
    end

    def token_valid?
      return true if @token.nil?
      return false if token_param.nil?
      token_param == @token
    end
  end
end
