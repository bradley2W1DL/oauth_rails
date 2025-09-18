class HomeController < ApplicationController
  def index
    ## Note! this wouldn't normally happen on the controller, but rather in the client app
    # for an easy POC, just generate it here...
    @code_verifier, @code_challenge, @challenge_method = Oauth::Pkce.generate_code_verifier_and_challenge

    auth_params = {
      response_type: "code",
      client_id: sample_client.client_id,
      redirect_uri: "http://localhost:3000/sample",
      scope: "read write",
      state: "sample-client-request",
      code_challenge: @code_challenge,
      code_challenge_method: @challenge_method,
    }
    # @sample_client = sample_client
    @test_authorize_url = authorize_url(auth_params)


    render :index
  end

  def sample
    @state = params[:state]
    @code = params[:code]

    render :sample
  end

  private

  def sample_client
    @sample_client ||= Client.first
  end
end
