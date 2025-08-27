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

  # should be an oauth thing...not sessions
  # def consent
  #   # params[:session] // pulled straight from cookie orrrr
  #   # need to know where to redirect to here...always the oauth#code endpoint?
  # end

  def create
    # Ultimately just want to check that user exists and password is correct
    # if so, create session, and return cookie, redirecting to /consent
    user = User.find_by(email: session_params[:username])

    if user&.authenticate(session_params[:password])
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
    # is current_user a thing here...? could it be
    # implement this in application controller by looking up user from session cookie
  end

  private

  def set_user_agent
    # TODO
    "Some devise, probably"
  end
end
