class StaticPagesController < ApplicationController
  def home
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5) if logged_in?
  end

  def about; end

  def terms; end
end
