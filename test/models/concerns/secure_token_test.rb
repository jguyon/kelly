require 'test_helper'

class Token < ActiveRecord::Base
  include SecureToken
end

class SecureTokenTest < ActiveSupport::TestCase
  setup do
    ActiveRecord::Base.connection.create_table :tokens do |t|
      t.string :token
    end
  end

  teardown do
    ActiveRecord::Base.connection.drop_table :tokens
  end

  test "generates a token on creation" do
    object = Token.create!
    assert_not_nil object.token
  end

  test "regenerates a token" do
    object = Token.create!
    old_token = object.token
    object.generate_token!
    assert_not_equal old_token, object.token
  end
end
