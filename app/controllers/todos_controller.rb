# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :find_todo_by_user, only: %i[destroy show activate switch
                                             share_todo update_progress]
  before_action :find_share_by_user, only: %i[switch]
  before_action :current_active, only: %i[activate switch destroy]
  before_action :list_todos, only: %i[create activate switch destroy]
  before_action :current_user_shares, only: %i[switch]
  respond_to :html, :js

  # fetching all todos of current user
  def index
    @search = params[:search].nil? ? '' : params[:search]
    @active = params[:active].nil? ? true : params[:active]
    list_todos
    page_rendering
  end

  # sharing to to other users
  def share_todo
    users = params[:users]
    @todo.create_share(users)
    redirect_to todo_path(@todo)
  end

  # creating new todo object
  def new
    @todo = @current_user.todos.build
  end

  # creating new todo with params
  def create
    @todo = @current_user.todos.build(todo_params)
    @todo.create_self_share(@current_user.id)
    list_todos
    if @todo.save
      flash.now[:success] = 'Todo inserted Successfully'
    else
      flash.now[:danger] = 'Todo cannot be inserted'
    end
    page_rendering
  end

  def activate
    @todo.update(active: !@todo.active)
    page_rendering
  end

  # switching priority
  def switch
    @direction=params[:direction]
    @switch_up = @share.priority_switch(@direction, @todo_shares)
    page_rendering
  end

  # deleting selected todo
  def destroy
    shared = @todo.shares.find_by(user_id: @current_user.id)
    shared.destroy_share(@todo)
    page_rendering
  end

  def show; end

  def update_progress
    progress = params[:progress].to_i
    comment_body = @todo.create_progress(progress, @current_user.id)
    redirect_to todo_path(@todo)
  end

  private

  # finding the todo which is in the current users ownership
  def find_todo_by_user
    @todo = @current_user.todos.find(params[:id])
  end

  def find_share_by_user
    @share = @current_user.shares.find_by(todo_id: params[:id])
  end

  # finding all todo
  def list_todos
    @active = @active.nil? ? true : @active
    @todos = @current_user.todos.search(@search)
                          .select_by_active(@active).sort_by_priority
    @todos = @todos.paginate(page: params[:page], per_page: 5)
  end

  def todo_params
    params.require(:todo).permit(:body, :user_id)
  end

  def  page_rendering
    respond_to do |format|
      format.html { render action: :index }
      format.json { head :no_content }
      format.js { render layout: false, locals: { active: params[:active] } }
    end
  end

  def current_active
    @active = @todo.active
  end

  def current_user_shares
    @todo_shares = @current_user.shares.joins("left outer join todos on todos.
      id=shares.todo_id and todos.active=#{@active}").sort_by_priority
  end
end
