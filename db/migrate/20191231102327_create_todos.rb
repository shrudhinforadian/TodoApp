class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.text :body
      t.boolean :active , :default=> true
      t.integer :priority
      t.references :user , foreign_key: true
      t.timestamps
    end
  end
end
