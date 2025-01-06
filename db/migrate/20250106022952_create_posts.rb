class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_enum :post_status, %w[draft published deleted]
    create_table :posts do |t|
      t.references :author, null: false, foreign_key: true
      t.boolean :is_commenting_enabled, null: false
      t.enum :status, enum_type: "post_status", default: "draft", null: false
      t.timestamps
    end
    add_index :posts, :status
  end
end
