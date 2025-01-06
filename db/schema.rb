# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_06_034608) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "post_status", ["draft", "published", "deleted"]

  create_table "authors", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "email", limit: 150, null: false
    t.string "password", limit: 12, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_authors_on_email", unique: true
  end

  create_table "post_revisions", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.boolean "active_revision"
    t.string "title", limit: 300
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_revisions_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.boolean "is_commenting_enabled", null: false
    t.enum "status", default: "draft", null: false, enum_type: "post_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["status"], name: "index_posts_on_status"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 60, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "post_revisions", "posts"
  add_foreign_key "posts", "authors"
end
