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

  context 'being validated' do
    let(:app) { fake_cookbook('app1'); Shak::Application.new('app1')}
    it 'is valid when input is valid' do
      expect(app.input).to receive(:valid?).and_return(true)
      expect(app).to be_valid
    end
    it 'is invalid when input is invalid' do
      expect(app.input).to receive(:valid?).and_return(false)
      expect(app).to_not be_valid
    end
    it 'uses input errors as its own' do
      errors = []
      expect(app.input).to receive(:errors).and_return(errors)
      expect(app.errors).to be(errors)
    end
  end

  context 'handling input data' do
    let(:app) { fake_cookbook('app1'); Shak::Application.new('app1')}
    it 'delegates has_key? to input_data' do
      allow(app).to receive(:input_data).and_return({'foo' => 'bar'})
      expect(app.has_key?('foo')).to be true
      expect(app.has_key?(:foo)).to be true
    end
    it 'does not set nil values' do
      expect(app).to_not receive(:path=)
      app.input_data = { 'path' => nil }
    end
    it 'does not set empty values' do
      expect(app).to_not receive(:path=)
      app.input_data = { 'path' => '' }
    end
    it 'ignores nil input data' do
      app.input_data = nil
    end
  end

  context 'producing labels' do
    let(:app) do
      fake_cookbook('app1')
      Shak::Application.new('app1')
    end
    it 'tolerates no label_format from input' do
      allow(app.input).to receive(:label_format).and_return(nil)
      expect(app.label).to eq('app1')
    end
    it 'interpolates input into label' do
      allow(app.input).to receive(:label_format).and_return('[%{hostname}]')
      allow(app).to receive(:input_data).and_return(hostname: 'foo.com')
      expect(app.label).to eq('[foo.com]')
    end
    it 'removes trailing slash from label' do
      allow(app).to receive(:label_format).and_return('foo.com/')
      expect(app.label).to eq('foo.com')
    end
  end

end
