class QuestionsController < ApplicationController
  before_action :logged_in_user, only: %i[destroy]
  def show
    @problem = Problem.find(params[:id])
  end

  def update
    @problem = Problem.find(params[:id])

    if @problem.answer == params[:problem][:answer]
      flash[:success] = '当たり'
      redirect_to root_url
    else
      flash.now[:danger] = 'はずれ'
      render 'show'
    end
  end
end
