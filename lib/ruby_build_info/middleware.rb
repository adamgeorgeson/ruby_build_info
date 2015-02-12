module RubyBuildInfo
  class Middleware
    require 'json'

    def initialize(app, options = {})
      @app = app
      @file_paths = options[:file_paths]
    end

    def call(env)
      if env['PATH_INFO'] == '/build_info'
        @build_info = {}
        @build_info[:git] = git_revision if git_revision
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
      unless @file_paths.nil?
        @file_paths.each do |file|
          raise "File does not exist: #{file}" unless File.exist? file
          @build_info[file] = `less #{file}`
        end
      end
    end

    def rails_info
      if defined? Rails
        result = Rails::Info.properties
        @build_info['Rails::Info'] = Hash[result]
      end
    end
  end
end
