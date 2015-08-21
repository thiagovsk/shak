require 'spec_helper'

require 'shak/operation/install'

require 'shak/operation/list'

describe Shak::Operation::List do

  let(:applications) { {} }
  let(:list) { described_class.new { |app| applications[app[:name]] = app } }
  let(:repository) { list.send(:repository) }

  def install(app, data={})
    fake_cookbook(app)
    dont_really_run_commands

    installer = Shak::Operation::Install.new(app)
    installer.input_data = data
    installer.perform
  end

  it 'lists installed apps' do
    install('app1')
    install('app2')
    list.perform

    expect(applications['app1']).to be_a(Hash)
    expect(applications['app2']).to be_a(Hash)
  end

  it 'generates http links' do
    install('static_site', { hostname: 'foo.com', path: '/bar' })
    list.perform
    expect(applications.values.last[:link]).to eq('http://foo.com/bar')
  end

  context 'application status' do
    it 'marks as outdated' do
      app = Object.new
      now = Time.now
      allow(app).to receive(:timestamp).and_return(now)
      allow(repository).to receive(:timestamp).and_return(now - 10)

      expect(list.send(:status, app)).to eq(:outdated)
    end

    it 'marks as uptodate' do
      app = Object.new
      now = Time.now
      allow(app).to receive(:timestamp).and_return(now)

      allow(repository).to receive(:timestamp).and_return(now + 10)
      expect(list.send(:status, app)).to eq(:uptodate)

      allow(repository).to receive(:timestamp).and_return(now)
      expect(list.send(:status, app)).to eq(:uptodate)
    end
  end

end
