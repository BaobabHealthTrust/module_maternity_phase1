# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_core_protocol_engine_session',
  :secret      => 'c4653128a4867325e3a6e5c2c70401a7af86ed9c52a08582a1bd34c4e36b6045da0cc09988550a557b829e2795a05254dd4603f7c5ab2d9b403307e110d0d102'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
