# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :find_todo_by_user, only: %i[destroy show activate up down]
  before_action :current_active, only: %i[activate down up destroy]
  before_action :list_todos, only: %i[create activate down up destroy]
  respond_to :html, :js

  # fetching all todos of current user
  def index
    @search=params[:search].nil? ? ' ' : params[:search]
    @active = params[:active].nil? ? true : params[:active]
    @active = first_todo.nil? ? true : first_todo.active if params[:active].nil?
    list_todos
    page_rendering
  end

  # creating new todo object
  def new
    @todo = @current_user.todos.build
  end

  def active

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

  def activate
    @todo.update(active: !@todo.active)
    page_rendering
  end

  # changing priority to down
  def down
    @up = @todos.where("priority<?",@todo.priority).first
    priority_switch
    page_rendering
  end

  # changing priority to up
  def up
    @up = @todos.where("priority>?",@todo.priority).last
    priority_switch
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
    @todos = @current_user.todos.where(active: @active).order(priority: :desc)
    @todos = @todos.where("body like ?" ,"%#{@search}%")
    @todos=@todos.paginate(:page => params[:page], :per_page => 5 )
  end


  # latest updated todo
  def first_todo
    @current_user.todos.order(updated_at: :desc).first
  end

  def todo_params
    params.require(:todo).permit(:body, :user_id)
  end

  def  page_rendering
    respond_to do |format|
      format.html { render action: :index }
      format.json { head :no_content }
      format.js { render layout: false , :locals => {:active => params[:active]}  }
    end
  end

  def current_active
    @active = @todo.active
  end

  def priority_switch
    priority_temp=@todo.priority
    @todo.change_priority(@up.priority)
    @up.change_priority(priority_temp)
  end
end
