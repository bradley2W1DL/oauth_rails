class HomeController < ApplicationController
  def index
    @test_authorize_url = "localhost:3000/authorize?response_type=code&client_id=#{Client.first.client_id}&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fsample&scope=read+write&state=xyz"

    render :index
  end

  def sample
    @state = params[:state]
    @code = params[:code]

    render :sample
  end
end
