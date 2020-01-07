class TodosController < ApplicationController

  before_action :find_todo_by_user, only: [:update, :destroy,:show,:active,:up,:down]
  #fetching all todos of current user
  def index
    # active= params[:value].to_s
    @active=true
    @active= !params[:active].nil? ? params[:active]  : @current_user.todos.
    order(updated_at: :desc).first.active unless @current_user.todos.last.nil?
    list_todos
  end
  #displaying selected todo
  def show

  end
  #creating new todo object
  def new
    @todo = @current_user.todos.build
  end
def edit
    redirect_to todos_path
end
  #creating new todo with params
  def create
    @todo = @current_user.todos.build(todo_params)
    if @todo.save

      redirect_to todos_path, flash: { success: 'Todo Successfully Inserted' }

    else

      redirect_to root_url, flash: {warning: 'Todo Insertion Failed!'}
    end
  end

  def update
    if @todo.update(todo_params)
      redirect_to todo_path, flash: { success: 'Todo Successfully Updated' }
    else
      flash.now[:warning] = 'Todo Updation Failed'
      render 'edit'
    end
  end
  #deleting selected todo
def active
    @todo.update(active: !@todo.active)
    redirect_to todos_path,
    flash: { success: 'Todo Successfully Actived #{@todo.active}' }


end
#changing priority to down
  def down
    @active=@todo.active
    list_todos
    @index=@todos.pluck(:id).index(@todo.id)+1
    change_priority
    redirect_to todos_path
  end
  #changing priority to up
  def up
    @active=@todo.active
    list_todos
    @index=@todos.pluck(:id).index(@todo.id)-1
    change_priority
    redirect_to todos_path
  end
  def destroy
    active=@todo.active
    @todo.destroy
    if @todo.destroy
      redirect_to todos_path(:active => active),
       flash: { success: 'Todo Successfully Deleted' }
    else
      flash.now[:success] = 'Todo Deletion Failed'
      render 'show'
    end
  end

  private
  #finding the todo which is in the current users ownership
  def find_todo_by_user
    @todo = @current_user.todos.find(params[:id])
  end
  #finding all todo
  def list_todos
    @todos = @current_user.todos.where(active: @active)
    @todos = @todos.order(priority: :desc)
  end
  def change_priority
    @up=@todos.limit(1).offset(@index)
    @up= @up[0]
    priority=@todo.priority
    @todo.update(priority: @up.priority)
    @up.update(priority: priority)
  end
  def todo_params
    params.require(:todo).permit( :body, :user_id)
  end
end
