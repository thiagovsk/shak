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

task :default => :spec

desc 'Runs unit tests with Rspec'
task :spec do
  sh 'rspec' unless Rake.application.rakefile != 'Rakefile'
end

desc 'Runs functional tests (against Debian package, using autopkgtest)'
task :test, [:adt_args] => :deb do |t, args|

  changes = Dir.glob('pkg/*.changes').first
  adt_args = String(args[:adt_args]).split

  sh 'adt-run', changes, *adt_args, '---', 'lxc', '--sudo', '--ephemeral', 'adt-jessie', '--', '--union-type', 'aufs'
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
  if !system('git diff-index --quiet HEAD')
    fail "Can't build package; you have uncommitted changes"
  end

  head = `git log --max-count=1 --format=%H`.strip
  pkg_head = nil
  if File.exist?('pkg/head')
    pkg_head = File.read('pkg/head').strip
  end

  if head != pkg_head
    rm_rf 'pkg'
    mkdir_p 'pkg'
    ENV['PATH'] = [File.expand_path('utils'), ENV['PATH']].join(':')
    sh 'git', 'debdry-build', '--git-export-dir=pkg'
    File.open('pkg/head', 'w') { |f| f.puts(head) }
  end
end

desc 'Edits changelog'
task :changelog do
  sh 'dch', '--changelog', 'changelog'
end

desc 'Adds a new cookbook'
task :cookbook do
  print "Cookbook name: "
  cookbook = $stdin.gets.strip
  sh 'knife', 'cookbook', 'create', cookbook, '-o', 'cookbooks/'
end

desc 'Find TODO|FIXME in the code'
task :todo do
  sh 'ack', '--ignore-file=is:Rakefile', '-C', 'TODO|FIXME'
end

desc 'Runs a Ruby console with the shak code loaded'
task :console do
  sh 'foreman run irb'
end
