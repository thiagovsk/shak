require 'spec_helper'

require 'shak/operation/list_available'

describe Shak::Operation::ListAvailable do
  it 'lists existing cookbooks' do
    data = []
    list_available = Shak::Operation::ListAvailable.new do |item|
      data << item
    end
    list_available.perform

    cookbook = data.find { |i| i[:name] == 'email' }
    expect(cookbook[:description]).to be_a(String)
    expect(cookbook[:long_description]).to be_a(String)
  end
end

