class ProblemsController < ApplicationController
  before_action :logged_in_user
  
 def new
  @problem = Problem.new
 end
end
