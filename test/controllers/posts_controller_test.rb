require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "PostsController" do
  setup { Post.delete_all }
  
  context "get index" do    
    setup { get("/posts") }

    asserts("Hello World") { last_response.body }.matches %r{Hello World}
  end
  
  context "get show" do
    setup do
      post = Post.create(:title => "Hello World",:body => "mongo blog is here")
      get "/posts/show/#{post.permalink}"
    end
    asserts("shows post body") { last_response.body }.matches %r{mongo blog is here}
    asserts("shows post title") { last_response.body }.matches %r{Hello World}
  end
end
