class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  concerning :GuestAuthentication do
    included do
      helper_method :current_guest
    end

    protected

      def current_guest
        @current_guest ||= get_guest_from_session ||
          get_guest_from_cookie ||
          create_guest
      end

    private

      def get_guest_from_session
        Guest.find_by(id: session[:guest_id]) if session[:guest_id]
      end

      def get_guest_from_cookie
        if cookies[:guest_token] &&
          guest = Guest.find_by(token: cookies[:guest_token])
          session[:guest_id] = guest.id
          guest
        end
      end

      def create_guest
        guest = Guest.create!
        cookies.permanent[:guest_token] = guest.token
        session[:guest_id] = guest.id
        guest
      end
  end
end
