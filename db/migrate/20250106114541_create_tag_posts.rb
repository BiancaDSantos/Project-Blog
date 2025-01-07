class CreateTagPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :tag_posts do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :post_revision, null: false, foreign_key: true
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
