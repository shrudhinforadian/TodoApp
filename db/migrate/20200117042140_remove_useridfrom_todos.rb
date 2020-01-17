class RemoveUseridfromTodos < ActiveRecord::Migration[5.2]
  def change
    remove_column :todos, :user_id
  end
end
