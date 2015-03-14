require 'spec_helper'
require 'shak/cookbook'

Shak::Cookbook.all.each do |cookbook|

  describe cookbook do
    let(:contents) { Dir.glob("cookbooks/#{cookbook.name}/**/*") }
    let(:directories) { contents.select { |d| File.directory?(d) } }

    it 'does not contain empty directories' do
      empty_dirs = directories.select { |d| Dir.glob("#{d}/**/*").empty? }
      expect(empty_dirs).to eq([])
    end
  end

end
