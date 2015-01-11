require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  def guest
    @guest ||= guests(:john)
  end

  test "gets guest from session" do
    session[:guest_id] = guest.id
    assert_equal guest, @controller.send(:current_guest)
  end

  test "gets guest from cookie" do
    cookies[:guest_token] = guest.token
    assert_equal guest, @controller.send(:current_guest)
    assert_equal guest.id, session[:guest_id]
  end

  test "creates new guest" do
    guest = nil
    assert_difference 'Guest.count' do
      guest = @controller.send(:current_guest)
    end
    assert_equal guest.token, cookies[:guest_token]
    assert_equal guest.id, session[:guest_id]
  end
end
