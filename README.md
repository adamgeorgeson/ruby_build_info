# BuildInfo

Rack middleware to output build information such as version control, bundled gems, and specified files to a webpage.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_build_info'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_build_info

## Usage

In your `config\environment\development.rb` or environment file of your choosing*:
    
    config.middleware.use(RubyBuildInfo::Middleware)

By default this will output Git revision, and output of `bundle show`.

You can specify an array optional file paths, such as version files.

    config.middleware.use(RubyBuildInfo::Middleware, file_paths: ['../custom_file_1', '../custom_file_2'])

*Unless it's production.rb - then I don't condone that.

## Contributing

1. Fork it ( https://github.com/adamgeorgeson/ruby_build_info/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
