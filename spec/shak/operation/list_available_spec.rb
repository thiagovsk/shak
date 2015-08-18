require 'spec_helper'

require 'shak/operation/list_available'

describe Shak::Operation::ListAvailable do

  let(:cookbooks) { [] }
  let(:list_available) do
    Shak::Operation::ListAvailable.new do |item|
      cookbooks << item
    end
  end

  before(:each) do
    list_available.perform
  end

  it 'lists existing cookbooks' do
    cookbook = cookbooks.find { |i| i[:name] == 'email' }
    expect(cookbook[:description]).to be_a(String)
    expect(cookbook[:long_description]).to be_a(String)
  end

  it 'does not list implicit cookbooks since they are always applied' do
    names = cookbooks.map { |i| i[:name] }
    expect(names).to_not include('shak', 'ssl')
  end


end

