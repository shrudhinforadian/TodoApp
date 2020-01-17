class CommentsController < ApplicationController
  before_action :searchtodo
  def create
    comment_params[:user_id] = @current_user.id
    description= comment_params[:description]
    @comment = @todo.comments.build(description: description ,user_id: @current_user.id)
    if @comment.save!
      flash[:success] = 'Comment inserted Successfully'
      redirect_to todo_path(@todo)
    else
      flash[:warning] = 'Cannot insert a blank comment'
      redirect_to todo_path(@todo)
    end
  end

  private

  def searchtodo
    @todo = Todo.find_by_id(params[:todo_id])
  end

  def comment_params
    params.require(:comment).permit(:description )
  end
end
