require 'spec_helper'
require 'shak/cookbook'
require 'shak/cookbook_input'

Shak::Cookbook.all.each do |cookbook|

  path = "cookbooks/#{cookbook.name}"

  describe path do

    before(:all) do
      @pwd = Dir.pwd
      Dir.chdir(path)
    end

    after(:all) do
      Dir.chdir(@pwd)
    end

    let(:contents) { Dir.glob('**/*') }
    let(:directories) { contents.select { |d| File.directory?(d) } }

    it 'contains no empty directories' do
      empty_dirs = directories.select { |d| Dir.glob("#{d}/**/*").empty? }
      expect(empty_dirs).to eq([])
    end

    it 'contains metadata.rb' do
      expect(contents).to include('metadata.rb')
    end

    it 'contains valid Ruby code in metadata.rb' do
      check = IO.popen(['ruby', '-c', 'metadata.rb'])
      check.close
      expect($?.exitstatus).to be(0)
    end

    it 'contains a README.md' do
      expect(contents).to include('README.md')
    end

    it 'contains a valid input file (if any)' do
      cookbook.input.check_semantics!
    end

  end

end
