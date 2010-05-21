PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")


# Hacked in support for factory_girl and mongoid
Dir[File.dirname(__FILE__) + '/../app/models/*.rb'].each do |model_file| 
  model_name = File.basename(model_file, '.rb')
  model_name.camelize.constantize.send(:include, Factoroid) 
end


class Riot::Situation
  include Rack::Test::Methods

  def app
    ##
    # You can handle all padrino applications using instead:
    #   Padrino.application
    MongoBlog.tap { |app|  }
  end
end
