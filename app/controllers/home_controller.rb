class HomeController < ApplicationController
  def index
    @test_authorize_url = "localhost:3000/authorize?response_type=code&client_id=#{Client.first.client_id}&redirect_uri=http%3A%2F%2Flocalhost%3A3030%2Fclient_app%2Fcallback&scope=read+write&state=xyz"

    render :index
  end
end
