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

ActiveRecord::Schema[7.0].define(version: 2024_10_11_152057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "material_id"
    t.index ["material_id"], name: "index_likes_on_material_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "material_evaluations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "material_id"
    t.float "evaluation"
    t.string "feature", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.index ["material_id"], name: "index_material_evaluations_on_material_id"
    t.index ["user_id"], name: "index_material_evaluations_on_user_id"
  end

  create_table "material_qualifications", force: :cascade do |t|
    t.bigint "material_id"
    t.bigint "qualification_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_material_qualifications_on_material_id"
    t.index ["qualification_id"], name: "index_material_qualifications_on_qualification_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "title", null: false
    t.string "image_link"
    t.date "published_date"
    t.text "info_link"
    t.string "systemid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "publisher"
    t.text "description"
    t.bigint "qualification_id"
  end

  create_table "qualifications", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.string "progress", null: false
    t.integer "year_acquired"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "material_id"
    t.index ["user_id"], name: "index_qualifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "name", null: false
    t.text "introduction"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "likes", "materials"
  add_foreign_key "likes", "users"
  add_foreign_key "material_evaluations", "materials"
  add_foreign_key "material_evaluations", "users"
  add_foreign_key "material_qualifications", "materials"
  add_foreign_key "material_qualifications", "qualifications"
  add_foreign_key "materials", "qualifications"
  add_foreign_key "qualifications", "materials"
  add_foreign_key "qualifications", "users"
end
