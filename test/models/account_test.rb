require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Account Model" do
  setup { Account.delete_all }

  context "definition" do
    setup { Account.generate }

    asserts_topic.has_field :name,             :type => String
    asserts_topic.has_field :surname,          :type => String
    asserts_topic.has_field :email,            :type => String
    asserts_topic.has_field :crypted_password, :type => String
    asserts_topic.has_field :salt,             :type => String
    asserts_topic.has_field :role,             :type => String

    asserts_topic.has_association :has_many_related, :posts

    asserts("crypted password") { !topic.crypted_password.nil? }
  end

  context "validation" do
    context "email" do
      asserts("on success") { Account.generate(:email => 'real@email.com') }
      asserts("on failure") { Account.generate(:email => 'dog') }.not!
    end
    context "password" do
      asserts("on success") { Account.generate(:password => 'test', :password_confirmation => 'test') }
      asserts("on failure") { Account.generate(:password => 'tes', :password_confirmation => '') }
    end
    context "role" do
      asserts("on success") { Account.generate(:role => 'admin') }
      asserts("on failure") { Account.generate(:role => '!@34s') }.not!
    end
  end

  context "authenticate" do
    setup { Account.generate(:email => 'test@test.com', :password => 'test', :password_confirmation => 'test') }

    asserts("on success") { topic.email }.equals Account.authenticate('test@test.com','test').email
    asserts("on failure") { Account.authenticate('test@test.com','fail') }.equals nil
  end
end
