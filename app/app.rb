class MongoBlog < Padrino::Application
  configure do
    register SassInitializer
    enable :sessions
  end
end