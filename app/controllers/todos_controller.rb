# frozen_string_literal: true

class TodosController < ApplicationController

  before_action :find_todo_by_user, only: %i[destroy show active up down]
  before_action :current_active, only: %i[active down up destroy]
  before_action :list_todos, only: %i[create active down up destroy]
  respond_to :html, :js
  # fetching all todos of current user
  def index
    @active = params[:active].nil? ? true : params[:active]
    @active = first_todo.nil? ? true : first_todo.active if params[:active].nil?
    list_todos
    page_rendering
  end

  # displaying selected todo
  def show
    page_rendering
  end

  # creating new todo object
  def new
    @todo = @current_user.todos.build
  end

  # creating new todo with params
  def create
    @todo = @current_user.todos.build(todo_params)
    list_todos
    if @todo.save
      page_rendering
    else
      page_rendering
    end
  end

  def active
    @active = @todo.active
    list_todos
    @todo.update(active: !@todo.active)
    page_rendering
  end

  # changing priority to down
  def down
    @index = @todos.pluck(:id).index(@todo.id) + 1
    change_priority
    page_rendering
  end

  # changing priority to up
  def up
    @index = @todos.pluck(:id).index(@todo.id) - 1
    change_priority
    page_rendering
  end

  # deleting selected todo
  def destroy
    if @todo.destroy
      page_rendering
    else
      page_rendering
    end
  end

  private

  # finding the todo which is in the current users ownership
  def find_todo_by_user
    @todo = @current_user.todos.find(params[:id])
  end

  # finding all todo
  def list_todos
    @active = @active.nil? ? true : @active
    @todos = @current_user.todos.where(active: @active)
    @todos = @todos.order(priority: :desc)
  end
  #priority switching
  def change_priority
    @up = @todos.limit(1).offset(@index)
    @up = @up[0]
    priority = @todo.priority
    @todo.update(priority: @up.priority)
    @up.update(priority: priority)
  end
  #latest updated todo
  def first_todo
    @current_user.todos.order(updated_at: :desc).first
  end

  def todo_params
    params.require(:todo).permit(:body, :user_id)
  end
end
def  page_rendering
  respond_to do |format|
    format.html { render action: :index }
    format.json { head :no_content }
    format.js { render layout: false }
  end
end
def current_active
  @active=@todo.active
end
