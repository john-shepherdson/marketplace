# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def destroy
    super
    cookies.delete(:internal_session)
    cookies.delete(:eosc_logged_in)
  end
end
