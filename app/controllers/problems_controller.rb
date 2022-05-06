class ProblemsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: %i[edit update]

  def index; end

  def show
    @problem = Problem.find(params[:id])
    @comment = Comment.new
  end

  def new
    @problem = Problem.new
  end

  def create
    @problem = current_user.problems.build(problem_params)
    @problem.picture.attach(params[:problem][:picture])
    if @problem.save
      flash[:success] = '問題が作成されました！'
      redirect_to problem_path(@problem)
    else
      render 'problems/new'
    end
  end

  def edit
    @problem = Problem.find(params[:id])
  end

  def update
    @problem = Problem.find(params[:id])
    if @problem.update(problem_params)
      flash[:succcess] = '問題情報が更新されました！'
      redirect_to @problem
    else
      render 'edit'
    end
  end

  def destroy
    @problem = Problem.find(params[:id])
    if current_user.admin? || current_user?(@problem.user)
      @problem.destroy
      flash[:success] = '問題が削除されました'
      redirect_to request.referer == user_url(@problem.user) ? user_url(@problem.user) : root_url
    else
      flash[:danger] = '別アカウントの問題は削除できません'
      redirect_to root_url
    end
  end

  private

    def problem_params
      params.require(:problem).permit(:study_type, :title, :explanation_text, :problem_text, :answer, :problem_explanation, :target_age, :reference, :picture)
    end

    def correct_user
      # 現在のユーザーが更新対象の問題を保有しているかどうか確認
      @problem = current_user.problems.find_by(id: params[:id])
      redirect_to root_url if @problem.nil?
    end
end
