require 'sinatra'
require 'shak/web/slim'

require 'shak/operation/list'

module Shak

  module Web

    class App < Sinatra::Base

      helpers do
        # TODO implement proper I18N
        def _(s)
          s
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

      # Adds a new app
      post '/' do
        # TODO
        true
      end

      # Browse available apps
      get '/add' do
        # TODO
        # true
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
