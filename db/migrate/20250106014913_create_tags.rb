class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, limit: 60, null: false
      t.timestamps
    end
  end
end
