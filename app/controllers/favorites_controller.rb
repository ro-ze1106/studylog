class FavoritesController < ApplicationController
  before_action :logged_in_user

  def create
    @problem = Problem.find(params[:dish_id])
    @user = @problem.user
    current_user.favorite(@problem)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    @problem = Problem.find(params[:dish_id])
    current_user.favorites.find_by(dish_id: @problem.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
