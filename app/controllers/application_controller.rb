require "application_responder"

class ApplicationController < ActionController::Base
  respond_to :html

  self.responder = ApplicationResponder

  before_action :gon_user
  before_action :check_real_email

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
      format.js   { head :forbidden }
    end
  end

  private

  def gon_user
    gon.user_id = current_user.id if user_signed_in?

    gon.is_user_signed_in = user_signed_in?
  end

  def check_real_email
    if current_user&.email_temp?
      return if ['confirmations', 'sessions'].include?(controller_name)
      redirect_to setup_email_user_path(current_user)
    end
  end
end
