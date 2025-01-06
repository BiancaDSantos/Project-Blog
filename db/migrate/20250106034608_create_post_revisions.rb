class CreatePostRevisions < ActiveRecord::Migration[8.0]
  def change
    create_table :post_revisions do |t|
      t.references :post, null: false, foreign_key: true
      t.boolean :active_revision
      t.string :title, limit: 300
      t.text :content

      t.timestamps
    end
  end
end
