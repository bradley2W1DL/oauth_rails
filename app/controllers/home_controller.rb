class HomeController < ApplicationController
  def index
    auth_params = {
      response_type: "code",
      client_id: sample_client.client_id,
      redirect_uri: "http://localhost:3000/sample",
      scope: "read write",
      state: "xyz"
    }
    @sample_client = sample_client
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
