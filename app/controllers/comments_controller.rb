class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @problem = Problem.find(params[:problem_id])
    @user = @problem.user
    @comment = @problem.comments.build(user_id: current_user.id, content: params[:comment][:content])
    if !@problem.nil? && @comment.save
      flash[:success] = "コメントを追加しました!"
    else
      flash[:danger] = "コメントを入力して下さい。"
    end
    redirect_to request.referrer || root_url
  end

  def destroy
  end
end
