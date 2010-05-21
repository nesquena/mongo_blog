MongoBlog.controllers :posts do
  
  get :index do
    render 'posts/index'
  end
  
  get :show, :with => :permalink do
    @post = Post.where(:permalink => params[:permalink]).first
    render 'posts/show'
  end
  
end