require 'fileutils'

ENV['SHAK_DATA_DIR'] = File.expand_path('../tmp/data', __FILE__)

module ShakSpecHelpers
  def fake_cookbook(name, input=nil)
    cookbook = Shak::Cookbook.send(:new, name)
    allow(Shak::Cookbook).to receive(:[]).with(name).and_return(cookbook)
    if input
      allow(cookbook).to receive(:input).and_return(input)
    end
  end

  def dont_really_run_commands
    allow(Shak).to receive(:run)
  end
end

unless ENV['ADTTMP']
  # not running autopkgtest
  ENV['PATH'] = [File.dirname(__FILE__) + '/../bin', ENV['PATH']].join(':')
  ENV['RUBYLIB'] = File.dirname(__FILE__) + '/../lib'
end

require 'open3'
module ShakCLIHelpers
  def sh(command)
    exit_status = nil
    Open3.popen3(command) do |stdin, stdout, stderr, process|
      @stdout = stdout.read
      @stderr = stderr.read
      exit_status = process.value
    end
    expect(exit_status).to eq(0)
  end
  attr_reader :stdout, :stderr
end

require 'shak/operation/install'
module ShakOperationHelpers
  def install(app, data)
    dont_really_run_commands
    installation = Shak::Operation::Install.new(app)
    installation.input_data = data
    installation.perform
  end
end

RSpec.configure do |config|
  config.include ShakSpecHelpers
  config.before(:each) do
    @tmpdir = ENV['SHAK_DATA_DIR']
  end
  config.after(:each) do
    FileUtils.rm_rf(ENV['SHAK_DATA_DIR'])
  end
end
