class MongoBlog < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register SassInitializer
  register DisqusInitializer
  
  enable :sessions

  get :root, :map => "/" do
    redirect url(:posts, :index)
  end

  get :about do
    render :haml, "%p Demonstrates the power of Padrino and MongoDB!"
  end
end
