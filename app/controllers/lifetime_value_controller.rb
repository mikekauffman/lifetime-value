class LifetimeValueController < ApplicationController
  def index
    @users = User.all
  end
end