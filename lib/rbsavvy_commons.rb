module RBSavvy
  def self.logger
    @@logger ||= ActiveSupport::TaggedLogging.new(RBSavvy::Logger.new)
  end

  def self.file_path(rel_path)
    path = File.expand_path("../#{rel_path}", __FILE__)
    path if File.exists?(path)
  end
end

# Dotenv
require 'dotenv'
Dotenv.load if Rails.env.test? or Rails.env.development?

# New Relic
ENV['NRCONFIG'] ||= RBSavvy.file_path("config/newrelic.yml")
require 'newrelic_rpm'


# Unicorn
require 'unicorn'
require 'rack/handler/rbsavvy'

# Random
require 'lograge'
require 'rails_serve_static_assets'
require 'rollbar'
require 'mutations'

# rbsavvy specific
require 'rbsavvy/logger'
require 'rbsavvy/railtie'

require 'rbsavvy/form'
require 'rbsavvy/database_transactions'

::NewRelic::Agent.logger = RBSavvy.logger