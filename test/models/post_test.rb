require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Post Model" do
  setup { Post.delete_all }
  
  context "definition" do
    setup { Post.spawn }
    
    asserts_topic.has_field :title,     :type => String
    asserts_topic.has_field :body,      :type => String
    asserts_topic.has_field :permalink, :type => String
    asserts_topic.has_field :tags,      :type => Array,   :default => []
    asserts_topic.has_field :draft,     :type => Boolean, :default => false
    
    asserts_topic.has_association :belongs_to_related, :account
    
    asserts_topic.respond_to :is_draft?
  end
  
  context "to_permalink" do
    setup { Post.generate(:title => "Hello World!",:body => "Mongo blog") }
    
    asserts("sets permalink") { topic.permalink }.equals "hello_world"
  end
    
end
