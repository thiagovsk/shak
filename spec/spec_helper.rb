require 'fileutils'

ENV['SHAK_DATA_DIR'] = File.expand_path('../tmp/data', __FILE__)

module ShakSpecHelpers
  def fake_cookbook(name)
    cookbook = Shak::Cookbook.send(:new, name)
    allow(Shak::Cookbook).to receive(:[]).with(name).and_return(cookbook)
  end

  def dont_really_run_commands
    allow(Shak).to receive(:run)
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
