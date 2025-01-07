class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :author, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.text :content, null: false, limit: 300

      t.timestamps
    end
  end
end
