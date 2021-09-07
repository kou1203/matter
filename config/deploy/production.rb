server '160.251.100.189', user: 'kou', roles: %w{app db web}, port: 49155

set :ssh_options, keys: '~/.ssh/conoha_vps/id_rsa'