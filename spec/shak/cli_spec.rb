require 'spec_helper'

require 'shak/cli'

describe Shak::CLI do

  let(:cli) { Shak::CLI.new }

  it 'parses options as a list of KEY=VALUE strigs' do
    cmdline = ['FOO=BAR', 'X=1']
    expect(cli.parse_extra_data(cmdline)).to eq({"FOO" => "BAR", 'X' => "1"})
  end

end
