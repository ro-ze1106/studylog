class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show index edit update destroy following followers]
  before_action :correct_user,   only: %i[edit update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @problems = @user.problems.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'スタディログへようこそ'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'プロフィールの編集が完了しました。'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    # 管理者ユーザーの場合
    if current_user.admin?
      @user.destroy
      flash[:success] = 'ユーザーの削除に成功しました'
      redirect_to users_url
    # 管理者ユーザーではないが、自分のアカウントの場合
    elsif current_user?(@user)
      @user.destroy
      flash[:success] = '自分のアカウントを削除しました'
      redirect_to root_url
    else
      flash[:danger] = '他人のアカウントは削除できません'
      redirect_to root_url
    end
  end

    def following
      @title = 'フォロー中'
      @user  = User.find(params[:id])
      @users = @user.following.paginate(page: params[:page])
      render 'show_follow'
    end

    def followers
      @title = 'フォロワー'
      @user  = User.find(params[:id])
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
    end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
