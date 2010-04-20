class MongoBlog < Padrino::Application
  configure do
    register SassInitializer
    enable :sessions
  end

  get :root, :map => "/" do
    redirect url(:posts, :index)
  end

  get :about do
    render :haml, "%p Demonstrates the power of Padrino and MongoDB!"
  end
end
