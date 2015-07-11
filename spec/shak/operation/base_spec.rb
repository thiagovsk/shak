require 'shak/operation/base'

describe Shak::Operation::Base do

  it 'uses a null UI by default' do
    expect(described_class.new.user_interface).to_not eq(nil)
  end
  it 'can have a UI set' do
    op = described_class.new
    ui = Object.new
    op.user_interface = ui
    expect(op.user_interface).to be(ui)
  end
end
