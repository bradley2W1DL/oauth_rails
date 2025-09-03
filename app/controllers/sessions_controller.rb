class SessionsController < ApplicationController
  before_action :update_auth_code, only: [:login]

  def login
    if current_user.present?
      # Maybe need to include client_id to check if THIS user has consented to THIS client
      redirect_to consent_path
    end

    render :login
  end

  def create
    # Ultimately just want to check that user exists and password is correct
    # if so, create session, and return cookie, redirecting to /consent
    user = User.find_by_factor(params[:username])
    Rails.logger.debug("\n#{__method__} Trace ID: #{@trace_id}\n")

    if user&.authenticate(params[:password])
      @user_session = UserSession.create!(
        user:,
        ip_address: request.remote_ip,
        user_agent: request.headers["User-Agent"]
      )
      session[:session_token] = @user_session.token

      update_auth_code

      redirect_to consent_path
    else
      flash[:error] = "Incorrect username or password"
      render :login
    end
  end

  def destroy
    # could a user ever have multiple sessions? Do we want to destroy them all on logout?
    UserSession.find_by(token: session[:session_token])&.destroy
  end

  private

  def update_auth_code
    auth_code_id = Rails.cache.fetch(code_cache_key)
    return if auth_code_id.blank?

    auth_code = AuthorizationCode.find_by(id: auth_code_id)

    if current_user.present?
      # TODO could this be more efficient?
      session = @user_session || UserSession.find_by(token: session[:session_token])
      auth_code.update(user: current_user, user_session: session)
    end
  end
end
