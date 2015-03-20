ENV['SHAK_DATA_DIR'] = File.expand_path('../tmp/data', __FILE__)

RSpec.configure do |config|
  config.color = true
  config.before(:each) do
    @tmpdir = ENV['SHAK_DATA_DIR']
  end
  config.after(:each) do
    FileUtils.rm_rf(ENV['SHAK_DATA_DIR'])
  end
end
