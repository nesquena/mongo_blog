require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Post Model" do
  setup { Post.delete_all }
  
  context "definition" do
    setup { Post.new }
    
    asserts_topic.has_field :title,     :type => String
    asserts_topic.has_field :body,      :type => String
    asserts_topic.has_field :permalink, :type => String
    asserts_topic.has_field :tags,      :type => Array
    asserts_topic.responds_to :to_permalink
  end
  
  context "to_permalink" do
    setup { Post.create(:title => "Hello World!",:body => "Mongo blog") }
    
    asserts("sets permalink") { topic.permalink }.equals "hello_world"
  end
    
end
