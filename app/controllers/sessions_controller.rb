class SessionsController < ApplicationController
  def login
    # check if session is already present in a cookie (how does rails handle setting and viewing cookies?)
    if current_user.present?
      # perform a lookup of the user_session based on cookie and pass this to consent...or will this still be
      # attached to the request?  Maybe need to include client_id to check if THIS user has consented to THIS client
      redirect_to consent_path
    end

    render :login
  end

  def create
    # Ultimately just want to check that user exists and password is correct
    # if so, create session, and return cookie, redirecting to /consent
    user = User.find_by(email: params[:username])

    Rails.logger.info("Looking for user #{params[:username]} --> found? #{user.present?}")

    if user&.authenticate(params[:password])
      user_session = UserSession.create!(
        user:,
        ip_address: request.remote_ip,
        user_agent: request.headers["User-Agent"]
      )

      session[:session_token] = user_session.token

      redirect_to consent_path # TODO, doubt this works
    else
      flash[:error] = "Incorrect username or password"
      render :login
    end
  end

  def destroy
    # could a user ever have multiple sessions? Do we want to destroy them all on logout?
    UserSession.find_by(token: session[:session_token])&.destroy
  end
end
