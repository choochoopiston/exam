# capistranoのバージョン固定
lock '3.4.0'

# デプロイするアプリケーション名
set :application, 'achieve'

# cloneするgitのレポジトリ
set :repo_url, ENV['REPO_URL']

# deployするブランチ。デフォルトはmasterなのでなくても可。
set :branch, 'master'

# deploy先のディレクトリ。
set :deploy_to, '/var/www/achieve'

# シンボリックリンクをはるファイル。(※後述)
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml')
set :linked_files, %w{ config/database.yml config/secrets.yml }

# シンボリックリンクをはるフォルダ。(※後述)
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# 保持するバージョンの個数(※後述)
set :keep_releases, 5

# rubyのバージョン
set :rbenv_ruby, '2.3.0'

#出力するログのレベル。
set :log_level, :debug

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end
  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
  task :copy_config do
    on release_roles :app do |role|
      fetch(:linked_files).each do |linked_file|
        user = role.user + "@" if role.user
        hostname = role.hostname
        linked_files(shared_path).each do |file|
          run_locally do
            execute :rsync, "config/#{file.to_s.gsub(/.*\/(.*)$/,"\\1")}", "#{user}#{hostname}:#{file.to_s.gsub(/(.*)\/[^\/]*$/, "\\1")}/"
          end
        end
      end
    end
  end
end
before "deploy:check:linked_files", "deploy:copy_config"
