# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# gem 'rest-client', '=1.6.3'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :action_web_service, :action_mailer, :active_resource ]
  config.log_level = :debug
  config.action_controller.session_store = :active_record_store
  config.active_record.schema_format = :sql

  config.action_controller.session = {
    :session_key => 'mateme_session',
    :secret      => '8sgdhr431ba87cfd9bea177ba3d344a67acb0f179753f37d28db8bd102134261cdb4b1dbacccb126435631686d66e148a203fac1c5d71eea6abf955a66a472ce'
  }
end

require 'composite_primary_keys'
require 'rest-client'