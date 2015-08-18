require 'sinatra'
require 'shak/web/slim'

require 'shak/operation/list'
require 'shak/operation/list_available'

module Shak

  module Web

    class App < Sinatra::Base

      helpers do
        # TODO implement proper I18N
        def _(s)
          s
        end

        def hostname
          @@hostname ||= `hostname --fqdn`.strip
        end
      end

      # Lists all installed apps
      get '/' do
        @apps = []
        list = Shak::Operation::List.new do |app|
          @apps << app
        end
        list.perform

        slim :index
      end

      # Browse available apps
      get '/browse' do
        @available = []
        list = Shak::Operation::ListAvailable.new do |app|
          @available << app
        end
        list.perform

        slim :browse
      end

      # Displays form to add a new app
      get '/add' do
        true
      end

      # Adds a new app
      post '/' do
        # TODO
        true
      end

      # views an installed app
      get '/:id' do
        # TODO
        true
      end

      # updates an installed app
      post '/:id' do
        # TODO
        true
      end

      # removes an installed app
      delete '/:id' do
        # TODO
        true
      end

    end

  end

end
