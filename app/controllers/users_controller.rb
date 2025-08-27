# # # #
# UsersController used to render basic pages to create new User accounts
#   And perform basic CRUD actions on those users -- generally locked down to admin users
#   but how? -- The external dashboard for user management could live elsewhere and authenticate
#   via our own Oauth mechanism and JWTs.
# # # #
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    # lock this route down to admins only
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  # admin only
  def show
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
