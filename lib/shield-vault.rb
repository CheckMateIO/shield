require "shield-vault/version"
require "thor"
require 'vault'

module ShieldVault
  class Commander < Thor
    class_option :app, desc: "specify which app this is for, default is current working directory"
    class_option :environment, desc: "specify which environment this is for", default: "development"

    desc "fetch", "Fetch all environment variables from Vault and write to .env file"
    long_desc <<-ADD
    `fetch` will fetch all environment variables from Vault and write to .env file.
    ADD
    def fetch
      check_seal do
        values = get_current_values
        if values
          File.open(file_name, 'w+') do |file|
            file.truncate(0)
            values.keys.each do |key|
              file.puts "#{key}=#{values[key]}\n"
            end
          end
          puts "Fetched environment variables and updated local #{file_name} file"
        else
          puts "No environment variables set for #{main_key} environment."
        end
      end
    end

    desc "add <key> <value>", "Add environment variable to Vault"
    long_desc <<-ADD
    `add <key> <value>` will add an environment variable to the Vault.
    ADD
    def add(key, value)
      check_seal do
        current_values = get_current_values
        current_values[key.to_sym] = value
        Vault.logical.write(main_key, current_values)
        puts "Added/updated environment variable in #{main_key}: #{key}"
      end
    end

    desc "update <key> <value>", "Update environment variable in Vault"
    long_desc <<-UPDATE
    `update <key> <value>` will update an environment variable to the Vault.
    UPDATE
    def update(key, value)
      invoke :add
    end

    desc "remove <key>", "Remove environment variable from Vault"
    long_desc <<-REMOVE
    `remove <key>` will remove an environment variable from the Vault.
    REMOVE
    def remove(key)
      check_seal do
        current_values = get_current_values
        if current_values[key.to_sym]
          current_values.delete key.to_sym
          if current_values.empty?
            Vault.logical.delete(main_key)
          else
            Vault.logical.write(main_key, current_values)
          end
          puts "Removed environment variable from #{main_key}: #{key}"
        else
          puts "Environment variable on #{main_key} does not exist: #{key}"
        end
      end
    end

    private

    def environment
      options[:environment] || "development"
    end

    def app
      #assume current directory is app name if option not passed in
      options[:app] || Dir.pwd.split('/').last
    end

    def get_current_values
      values = Vault.logical.read(main_key)
      values ? values.data : {}
    end

    def main_key
      "secret/#{app}_#{environment}_env_vars"
    end

    def file_name
      @file_name ||= case environment
      when 'development'
        File.join(Dir.pwd, '.env')
      when 'staging'
        File.join(Dir.pwd, '.env.staging')
      when 'production'
        File.join(Dir.pwd, '.env.production')
      else
        nil
      end
    end

    def check_seal(&block)
      if Vault.sys.seal_status.sealed
        puts "Vault is sealed.  You must unseal it to interact with it."
        return
      end
      block.call
    end
  end
end
