require_relative 'base'

class Shak::Operation::List < Shak::Operation::Base

  def initialize(callback)
    @callback = callback
  end

  def perform
    repository.each do |app|
      @callback.call({
        name: app.name,
        id: app.id,
        link: link_to(app),
      })
    end
  end

  protected

  def link_to(app)
    if app.has_key?(:hostname) && app.has_key?(:path)
      "http://#{app.hostname}#{app.path}"
    else
      nil
    end
  end

end
