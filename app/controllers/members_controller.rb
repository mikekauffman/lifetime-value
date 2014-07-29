class MembersController < ApplicationController
  def index
    members = Member.new
    @current_members = members.filter_current(User.all)
  end
end