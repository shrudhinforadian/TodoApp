class AddColumnProgress < ActiveRecord::Migration[5.2]
  def change
    add_column :todos, :status, :integer ,:default=> 0
  end
end
