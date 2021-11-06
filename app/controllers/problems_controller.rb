class ProblemsController < ApplicationController
  before_action :logged_in_user
  
 def new
  @problem = Problem.new
 end

 def create
  @problem = current_user.problems.build(problem_params)
  if @problem.save
    flash[:success] = "問題が作成されました！"
    redirect_to root_url
  else
    render 'problems/new'
  end
end

  private

  def problem_params
    params.require(:problem).permit(:study_type, :title, :explanation_text, :problem_text, :answer, :problem_explanation, :taget_age, :reference)
  end
end
