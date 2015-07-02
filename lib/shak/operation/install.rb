require_relative 'base'
require_relative 'apply_configuration'

require 'shak/application'

module Shak
  module Operation
    class Install < Base
      def initialize(apps)
        @apps = apps
      end

      def perform
        add_applications
        apply_configuration
      end

      protected

      def add_applications
        @apps.each do |appname|
          app = Shak::Application.new(appname)
          repository.add(app)
        end
        write_repository
      end

      def apply_configuration
        apply = Shak::Operation::ApplyConfiguration.new
        apply.perform
      end

    end
  end
end
