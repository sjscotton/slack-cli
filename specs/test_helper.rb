require "simplecov"
SimpleCov.start

require "minitest"
require "minitest/autorun"
require "minitest/reporters"
require "minitest/skip_dsl"
require "HTTParty"
require "vcr"
require "webmock/minitest"
require "dotenv"
require "pry"
Dotenv.load

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
  config.cassette_library_dir = "specs/cassettes"
  config.hook_into :webmock
  config.default_cassette_options = {
    :record => :new_episodes,
    :match_requests_on => [:method, :uri, :body],
  }

  config.filter_sensitive_data("<SLACK_TOKEN>") do
    ENV["TOKEN"]
  end
end

require_relative "../lib/recipient.rb"
require_relative "../lib/user.rb"
require_relative "../lib/channel.rb"
require_relative "../lib/workspace.rb"
