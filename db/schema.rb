# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_17_103900) do

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "description"
    t.bigint "user_id"
    t.bigint "todo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["todo_id"], name: "index_comments_on_todo_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "shares", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "is_owner", default: true
    t.integer "priority"
    t.bigint "user_id"
    t.bigint "todo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["todo_id"], name: "index_shares_on_todo_id"
    t.index ["user_id"], name: "index_shares_on_user_id"
  end

  create_table "todos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "body"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "comments", "todos"
  add_foreign_key "comments", "users"
  add_foreign_key "shares", "todos"
  add_foreign_key "shares", "users"
end
