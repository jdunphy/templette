set :package_name, 'package'
set :staging_path,    ''
set :user,            "username"

task :staging do
  role :web,  'staging.example.com'
  set :deploy_path, 'public_html/staging_path'
end

task :production do
  role :web, 'example.com'
  set :deploy_path, 'public_html/path'
end

before "deploy", "package"
after "deploy", "cleanup"

task :package do
 `rake build destination=#{package_name}`
 `tar -czvf #{package_name}.tar.gz #{package_name}`
end

desc "This is the main task"
task :deploy, :roles => [:web] do
 upload "#{package_name}.tar.gz", "#{staging_path}#{package_name}.tar.gz"
 run "tar -xzvf #{staging_path}#{package_name}.tar.gz"
 run "rsync -r #{staging_path}#{package_name}/ #{deploy_path}"
end

task :cleanup do
  run "rm -f #{staging_path}/#{package_name}"
  run "rm -rf #{staging_path}#{package_name}"
  `rm -rf #{package_name}.tar.gz`
end

