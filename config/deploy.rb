# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

# デプロイするアプリケーション名
set :application, "matter"

# cloneするgitのレポジトリ
# 1-3で設定したリモートリポジトリのurl
set :repo_url, 'git@github.com:kou1203/matter.git'

# deployするブランチ。デフォルトはmasterなのでなくても可。
set :branch, 'master'

# railsのルートディレクトリを指定
# set :rails_root, 'server'

# deploy先のディレクトリ。
set :deploy_to, '/var/www/matter'

# Default value for :pty is false
set :pty, true

# シンボリックリンクをはるファイル
# append :linked_files, "config/master.key"
# append :linked_files, "config/credentials/production.key"
set :linked_files, fetch(:linked_files, []).push("config/credentials/production.key")
# シンボリックリンクをはるフォルダ
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system"

# gem_bundle path指定
# set :bundle_gemfile,  "/20220211105419/Gemfile"

# 保持するバージョンの個数(※後述)
set :keep_releases, 3

# rubyのバージョン
# rbenvで設定したサーバー側のrubyのバージョン
set :rbenv_ruby, '2.7.5'

# 出力するログのレベル。
set :log_level, :debug

# パスの固定
set :bundle_binstubs, -> { shared_path.join('bin') }

# デプロイのタスク
namespace :deploy do

  # unicornの再起動
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  # データベースの作成
  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
                # データベース作成のsqlセット
                # データベース名はdatabase.ymlに設定した名前で
                  sql = "CREATE DATABASE IF NOT EXISTS hoge_app_production;"
                # クエリの実行。
                # userとpasswordはmysqlの設定に合わせて
                execute "mysql --user=root --password=root -e '#{sql}'"

        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end