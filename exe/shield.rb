#!/usr/bin/env ruby

require 'shield'
require 'vault'

# Vault config
Vault.configure do |config|
  # The address of the Vault server, also read as ENV["VAULT_ADDR"]
  config.address = ENV['VAULT_ADDR'] || 'https://127.0.0.1:8200'

  # The token to authenticate with Vault, also read as ENV["VAULT_TOKEN"]
  config.token = ENV['VAULT_TOKEN'] || "abcd-1234"
end

Shield::Commander.start(ARGV)