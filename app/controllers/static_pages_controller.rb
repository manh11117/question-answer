class StaticPagesController < ApplicationController
  def home
    @activities = current_user.feed.paginate page: params[:page] if logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
