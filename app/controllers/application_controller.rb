class ApplicationController < ActionController::Base
  before_action :set_search
  include SessionsHelper

  # フィードから検索条件に該当する問題を検索
  def set_search
    if logged_in?
      @search_word = params[:q][:study_type_or_title_or_target_age_cont] if params[:q]
      @q = current_user.feed.paginate(page: params[:page], per_page: 5).ransack(params[:q])
      @problems = @q.result(distinct: true)
    end
  end

  private

    # ログイン済みユーザーかどうか確認(採用担当者様ログイン用)
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = 'ログインしてください'
        redirect_to recruit_login_url
      end
    end
end
