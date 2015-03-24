require 'spec_helper'

require 'shak/cli'

describe Shak::CLI do

  let(:cli) { Shak::CLI.new }

  it 'parses options as a list of KEY=VALUE strigs' do
    cmdline = ['FOO=BAR', 'X=1']
    expect(cli.parse_extra_data(cmdline)).to eq({"FOO" => "BAR", 'X' => "1"})
  end

  it 'finishes pager at the end of #run' do
    allow(cli).to receive(:run!)
    expect(cli).to receive(:finish_pager)
    cli.run
  end

  it 'closes pager on #finish_pager' do
    pager = Object.new
    expect(IO).to receive(:popen).with(anything, ['pager'], 'w').and_return(pager)
    cli.pager

    expect(pager).to receive(:close)
    cli.finish_pager
  end

end
