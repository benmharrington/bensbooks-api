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

ActiveRecord::Schema[8.0].define(version: 2025_04_09_233949) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.string "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id"
    t.index ["author_id"], name: "index_books_on_author_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "book_id"
    t.integer "score", null: false
    t.text "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_ratings_on_book_id"
    t.index ["user_id", "book_id"], name: "index_ratings_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "synopses", force: :cascade do |t|
    t.text "content"
    t.bigint "book_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "upvotes", default: 0, null: false
    t.integer "downvotes", default: 0, null: false
    t.index ["book_id"], name: "index_synopses_on_book_id"
    t.index ["user_id"], name: "index_synopses_on_user_id"
  end

  create_table "synopsis_votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "synopsis_id", null: false
    t.integer "vote", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["synopsis_id"], name: "index_synopsis_votes_on_synopsis_id"
    t.index ["user_id", "synopsis_id"], name: "index_synopsis_votes_on_user_id_and_synopsis_id", unique: true
    t.index ["user_id"], name: "index_synopsis_votes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "books", "authors"
  add_foreign_key "ratings", "books"
  add_foreign_key "ratings", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "synopses", "books"
  add_foreign_key "synopses", "users"
  add_foreign_key "synopsis_votes", "synopses"
  add_foreign_key "synopsis_votes", "users"
end
