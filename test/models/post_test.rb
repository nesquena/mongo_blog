require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class PostControllerTest < Test::Unit::TestCase
  context "Post Model" do
    should 'construct new instance' do
      @post = Post.new
      assert_not_nil @post
    end
  end
end
