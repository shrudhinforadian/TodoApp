class CommentsController < ApplicationController
  before_action :searchtodo
  def create
    comment_params[:user_id] = @current_user.id
    description= comment_params[:description]
    @comment = @todo.comments.build(description: description ,user_id: @current_user.id)
    if @comment.save!
      flash[:success] = 'Comment inserted Successfully'
      page_rendering

    else
      flash[:warning] = 'Cannot insert a blank comment'
      page_rendering
    end
  end

  private

  def searchtodo
    @todo = Todo.find_by_id(params[:todo_id])
  end

  def comment_params
    params.require(:comment).permit(:description )
  end

  def page_rendering
    respond_to do |format|
      format.html { render action: 'todo/show' }
      format.json { head :no_content }
      format.js { render layout: false , :locals => {:id => @todo.id}  }
    end
  end
end
