class CreateShares < ActiveRecord::Migration[5.2]
  def change
    create_table :shares do |t|
      t.boolean :is_owner, :default=> true
      t.integer :priority
      t.references :user , foreign_key: true
      t.references :todo , foreign_key: true
      t.timestamps
    end
  end
end
