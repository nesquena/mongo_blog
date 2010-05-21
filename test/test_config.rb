PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

class Riot::Situation
  include Rack::Test::Methods

  def app
    ##
    # You can handle all padrino applications using instead:
    #   Padrino.application
    MongoBlog.tap { |app|  }
  end
end
