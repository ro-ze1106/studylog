class FavoritesController < ApplicationController
  before_action :logged_in_user

  def index
    @favorites = current_user.favorites
  end

  def create
    @problem = Problem.find(params[:problem_id])
    @user = @problem.user
    current_user.favorite(@problem)
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
    # 自分以外のユーザーからお気に入り登録があった時のみ通知を作成
    if @user != current_user
      @user.notifications.create(problem_id: @problem.id, variety: 1,
                                 from_user_id: current_user.id) # お気に入り登録は通知差別1
      @user.update_attribute(:notification, true)
    end
  end

  def destroy
    @problem = Problem.find(params[:problem_id])
    current_user.favorites.find_by(problem_id: @problem.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end
end
