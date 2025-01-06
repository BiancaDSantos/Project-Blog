class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :name, limit: 100, null: false
      t.string :email, limit: 150, null: false
      t.string :password, limit: 12, null: false
      t.timestamps
    end
    add_index :authors, :email, unique: true
  end
end
