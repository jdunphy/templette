set :package_name, 'package.tar.gz'
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
 `rake build`
 `tar -czvf #{package_name} out`
end

desc "This is the main task"
task :deploy, :roles => [:web] do
 upload package_name, "#{staging_path}#{package_name}"
 run "tar -xzvf #{staging_path}#{package_name}"
 run "rsync -r out/ #{deploy_path}"
end

task :cleanup do
  run "rm -f #{staging_path}/#{package_name}"
  run "rm -rf out"
  `rm -f #{package_name}`
end
