require_relative 'base'

class Shak::Operation::Config < Shak::Operation::Base

  def initialize(id)
    @application = repository.find(id)
  end

  def input_data=(data)
    @application.input_data = data
  end
  attr_reader :application

  def perform
    write_repository
  end

end
