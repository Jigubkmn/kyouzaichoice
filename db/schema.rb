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

ActiveRecord::Schema[7.0].define(version: 2024_08_31_140828) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.text "body", null: false
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_likes_on_commentable"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "material_evaluations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "material_id"
    t.float "evaluation"
    t.string "feature", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_material_evaluations_on_material_id"
    t.index ["user_id"], name: "index_material_evaluations_on_user_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "title", null: false
    t.string "image_link", null: false
    t.date "published_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "info_link"
    t.string "systemid"
  end

  create_table "qualifications", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.string "progress", null: false
    t.integer "year_acquired"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_qualifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password", null: false
    t.string "salt"
    t.string "name", null: false
    t.text "introduction"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "comments", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "material_evaluations", "materials"
  add_foreign_key "material_evaluations", "users"
  add_foreign_key "qualifications", "users"
end
