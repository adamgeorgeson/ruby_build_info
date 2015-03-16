# RubyBuildInfo [![Gem Version](https://badge.fury.io/rb/ruby_build_info@2x.png)](http://badge.fury.io/rb/ruby_build_info)

Rack middleware to output build information such as version control, bundled gems, and specified files to JSON.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_build_info'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_build_info
    
In your `config\environment\development.rb` or environment file of your choosing*:
    
    config.middleware.use(RubyBuildInfo::Middleware)

By default this will output Git revision, and output of `bundle show`.

You can specify an array optional file paths, such as version files.

    config.middleware.use(RubyBuildInfo::Middleware, file_paths: ['../custom_file_1', '../custom_file_2'])

*Unless it's production.rb - then I don't condone that.

## Usage

Go to /build_info in your Ruby application to see output.

## Example Output

```
{
  "git": "2015-02-09 a94bb12  (HEAD, tag: v9.9.9, testing_build_info)",
  "Rails::Info": {
    "Ruby version": "2.1.5-p273 (x86_64-darwin14.0)",
    "RubyGems version": "2.2.2",
    "Rack version": "1.5",
    "Rails version": "4.1.8",
    "JavaScript Runtime": "JavaScriptCore",
    "Active Record version": "4.1.8",
    "Action Pack version": "4.1.8",
    "Action View version": "4.1.8",
    "Action Mailer version": "4.1.8",
    "Active Support version": "4.1.8",
    "Middleware": [
      "Rack::Sendfile",
      "ActionDispatch::Static",
      "Rack::Lock",
      "#<ActiveSupport::Cache::Strategy::LocalCache::Middleware:0x007fb8b17f3228>",
      "Rack::Runtime",
      "Rack::MethodOverride",
      "ActionDispatch::RequestId",
      "Rails::Rack::Logger",
      "ActionDispatch::ShowExceptions",
      "ActionDispatch::DebugExceptions",
      "ActionDispatch::RemoteIp",
      "ActionDispatch::Reloader",
      "ActionDispatch::Callbacks",
      "ActiveRecord::Migration::CheckPending",
      "ActiveRecord::ConnectionAdapters::ConnectionManagement",
      "ActiveRecord::QueryCache",
      "ActionDispatch::Cookies",
      "ActionDispatch::Session::CookieStore",
      "ActionDispatch::Flash",
      "ActionDispatch::ParamsParser",
      "Rack::Head",
      "Rack::ConditionalGet",
      "Rack::ETag",
      "RubyBuildInfo::Middleware"
    ],
    "Application root": "/Users/adamgeorgeson/dev/git_app",
    "Environment": "development",
    "Database adapter": "sqlite3",
    "Database schema version": 0
  },
  "gems": [
    "Gems included by the bundle:",
    "actionmailer (4.1.8)",
    "actionpack (4.1.8)",
    "actionview (4.1.8)",
    "activemodel (4.1.8)",
    "activerecord (4.1.8)",
    "activesupport (4.1.8)",
    "arel (5.0.1.20140414130214)",
    "builder (3.2.2)",
    "bundler (1.8.0)",
    "coffee-rails (4.0.1)",
    "coffee-script (2.3.0)",
    "coffee-script-source (1.9.0)",
    "erubis (2.7.0)",
    "execjs (2.3.0)",
    "hike (1.2.3)",
    "i18n (0.7.0)",
    "jbuilder (2.2.6)",
    "jquery-rails (3.1.2)",
    "json (1.8.2)",
    "mail (2.6.3)",
    "mime-types (2.4.3)",
    "minitest (5.5.1)",
    "multi_json (1.10.1)",
    "rack (1.5.2)",
    "rack-test (0.6.3)",
    "rails (4.1.8)",
    "railties (4.1.8)",
    "rake (10.4.2)",
    "rdoc (4.2.0)",
    "ruby_build_info (1.0.1)",
    "sass (3.2.19)",
    "sass-rails (4.0.5)",
    "sdoc (0.4.1)",
    "spring (1.3.1)",
    "sprockets (2.12.3)",
    "sprockets-rails (2.2.4)",
    "sqlite3 (1.3.10)",
    "thor (0.19.1)",
    "thread_safe (0.3.4)",
    "tilt (1.4.1)",
    "turbolinks (2.5.3)",
    "tzinfo (1.2.2)",
    "uglifier (2.7.0)"
  ]
}
```

## Viewing tools
When viewing JSON in a browser, you can use a plugin for a prettier
view. An example Chrome extension: https://github.com/gildas-lormeau/JSONView-for-Chrome

## Contributing

1. Fork it ( https://github.com/adamgeorgeson/ruby_build_info/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
