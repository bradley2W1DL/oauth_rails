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

ActiveRecord::Schema[8.0].define(version: 2025_08_29_053500) do
  create_table "authorization_codes", force: :cascade do |t|
    t.integer "client_id", null: false
    t.integer "user_id"
    t.integer "user_session_id"
    t.text "redirect_uri"
    t.json "scope"
    t.text "code_challenge"
    t.string "code_challenge_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_authorization_codes_on_client_id"
    t.index ["user_id"], name: "index_authorization_codes_on_user_id"
    t.index ["user_session_id"], name: "index_authorization_codes_on_user_session_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "client_id"
    t.string "client_secret"
    t.json "redirect_uris", default: []
    t.integer "application_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.text "token"
    t.integer "client_id", null: false
    t.integer "user_id", null: false
    t.integer "user_session_id", null: false
    t.json "scope"
    t.datetime "issued_at"
    t.datetime "expires_at"
    t.boolean "revoked", default: false
    t.integer "parent_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_refresh_tokens_on_client_id"
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
    t.index ["user_session_id"], name: "index_refresh_tokens_on_user_session_id"
  end

  create_table "user_consents", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "client_id", null: false
    t.json "scope"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_user_consents_on_client_id"
    t.index ["user_id"], name: "index_user_consents_on_user_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "token", null: false
    t.datetime "expires_at", null: false
    t.datetime "last_active"
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "authorization_codes", "clients"
  add_foreign_key "authorization_codes", "user_sessions"
  add_foreign_key "authorization_codes", "users"
  add_foreign_key "refresh_tokens", "clients"
  add_foreign_key "refresh_tokens", "user_sessions"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "user_consents", "clients"
  add_foreign_key "user_consents", "users"
  add_foreign_key "user_sessions", "users"
end
