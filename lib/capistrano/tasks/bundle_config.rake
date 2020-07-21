# frozen_string_literal: true

# Temporary solution for deprecation warnings of bundler v2.1+.
# https://github.com/capistrano/bundler/issues/115

namespace :load do
  task :defaults do
    set :bundle_flags, '--quiet'
    set :bundle_path, nil
    set :bundle_without, nil
    set :bundle_config_flags, {
      path: -> { shared_path.join('bundle') },
      without: %w[development test].join(':'),
      deployment: 'true'
    }
    # set :bundle_env_variables, lambda {
    #   {
    #     bundle_path: shared_path.join('bundle').to_s,
    #     bundle_without: %w[development test].join(':'),
    #     bundle_deployment: 'true'
    #   }
    # }
  end
end

namespace :bundler do
  task :config do
    on fetch(:bundle_servers) do
      within release_path do
        with fetch(:bundle_env_variables) do
          fetch(:bundle_config_flags).each do |name, value|
            value = value.call if value.respond_to?(:call)
            execute :bundle, :config, '--local', name, value
          end
        end
      end
    end
  end
end

# You could comment out this hook and set `linked_dirs` in `deploy.rb`
# 
#   append :linked_dirs, '.bundle'
#
# And run hook once manually when first deploy or `bundle_config_flags` is changed.
#
#   after 'deploy:check, 'bundler:config'
#
before 'bundler:install', 'bundler:config'