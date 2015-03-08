{
  :build => :build,
  :release => :release,
  :snapshot => :install,
}.each do |local_task, bundler_task|
  desc "Runs the #{bundler_task} task from bundler"
  task local_task do
    sh 'rake', '-f', 'Rakefile.bundler', bundler_task.to_s
  end
end

desc 'Builds everything that needs to be built'
task :default do
  sh 'rspec', '--color'
end

desc 'Installs files into DESTDIR (or /)'
task :install do
  destdir = ENV.fetch('DESTDIR', '/')

  if File.directory?('debian')
    Dir.glob('{cookbooks}/**/*').each do |f|
      next if File.directory?(f)
      dir = File.join(destdir, '/usr/lib/ruby/vendor_ruby/shak', File.dirname(f))
      mkdir_p dir
      install f, dir, :mode => 0644
    end
  end

  Dir.glob('etc/**/*').each do |f|
    next if File.directory?(f)
    dir = File.join(destdir, File.dirname(f))
    mkdir_p dir
    install f, dir, :mode => 0644
  end
end

desc 'Builds Debian package'
task :deb do
  mkdir_p 'pkg'
  ENV['PATH'] = [File.expand_path('utils'), ENV['PATH']].join(':')
  sh 'git', 'debdry-build', '--git-export-dir=pkg'
end
