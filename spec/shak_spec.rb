require 'shak'

describe Shak do
  it 'raises an exception on failed commands' do
    expect(lambda { Shak.run('false') }).to raise_error(Shak::CommandFailed)
  end
end
