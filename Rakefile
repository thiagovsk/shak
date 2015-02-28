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
  # hook into gem2deb
  if Dir.exists?('debian')
    ln_s '../Rakefile', 'debian/dh_ruby.rake'
  end
end

desc 'Installs files into DESTDIR (or /)'
task :install do
  if Dir.exists?('debian')
    prefix = '/usr'
  else
    prefix = '/usr/local'
  end
  destdir = ENV['DESTDIR']

  Dir.glob('{cookbooks}/**/*').each do |f|
    next if File.directory?(f)
    dir = File.join(destdir, prefix, 'share', File.dirname(f))
    mkdir_p dir
    install f, dir, :mode => 0644
  end

  Dir.glob('etc/**/*').each do |f|
    next if File.directory?(f)
    dir = File.join(destdir, File.dirname(f))
    mkdir_p dir
    install f, dir, :mode => 0644
  end
end

desc 'cleans up the build'
task :clean do
  rm_rf 'pkg'
  rm_f 'debian/dh_ruby.rake'
end
