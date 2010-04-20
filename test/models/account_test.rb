require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class AccountControllerTest < Test::Unit::TestCase
  context "Account Model" do
    should 'construct new instance' do
      @account = Account.new
      assert_not_nil @account
    end
  end
end
