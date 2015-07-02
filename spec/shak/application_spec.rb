require "spec_helper"

require 'shak/application'

describe Shak::Application do

  context 'referencing cookbook' do
    let(:app) { Shak::Application.new('shak') }
    let(:cookbook) { Shak::Cookbook.send(:new, 'foo') }

    it 'returns an Shak::Cookbook instance' do
      expect(app.cookbook).to be_a(Shak::Cookbook)
    end
  end

  context 'calculatring instance_id' do
    let(:app) { Shak::Application.new('shak', 'foo-bar-baz')}
    it 'turns dashes into underscores' do
      expect(app.instance_id).to eq('foo_bar_baz')
    end

  end

end
