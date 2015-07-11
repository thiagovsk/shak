require_relative 'base'
require_relative 'apply_configuration'

require 'shak/application'

module Shak
  module Operation
    class Install < Base

      attr_reader :application

      def initialize(app_name)
        @application = Shak::Application.new(app_name)
      end

      def input_data=(data)
        application.input_data = data
      end

      def perform
        add_applications
        apply_configuration
      end

      protected

      def add_applications
        application.validate_input!
        repository.add(application)
        write_repository
      rescue Shak::Application::InvalidInput => ex
        ex.errors.each do |error|
          user_interface.display_error error
        end
        user_interface.abort
      end

      def apply_configuration
        apply = Shak::Operation::ApplyConfiguration.new
        apply.perform
      end

    end
  end
end
