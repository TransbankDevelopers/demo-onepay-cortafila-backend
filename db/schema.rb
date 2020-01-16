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

ActiveRecord::Schema.define(version: 2020_01_16_194543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "buy_transactions", force: :cascade do |t|
    t.string "status"
    t.string "response_code"
    t.string "description"
    t.string "occ"
    t.string "authorizationCode"
    t.datetime "issuedAt"
    t.string "signature"
    t.integer "amount"
    t.string "transactionDesc"
    t.integer "installmentsAmount"
    t.integer "installmentsNumber"
    t.string "buyOrder"
    t.bigint "ShoppingCart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_unique_number"
    t.string "ott"
    t.index ["ShoppingCart_id"], name: "index_buy_transactions_on_ShoppingCart_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "deviceid"
    t.string "fcmtoken"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "source"
  end

  create_table "items", force: :cascade do |t|
    t.integer "amount"
    t.integer "quantity"
    t.string "description"
    t.string "additional_data"
    t.integer "expire"
    t.bigint "shopping_cart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopping_cart_id"], name: "index_items_on_shopping_cart_id"
  end

  create_table "shopping_carts", force: :cascade do |t|
    t.string "occ"
    t.string "ott"
    t.string "external_unique_number"
    t.integer "issued_at"
    t.integer "amount"
    t.bigint "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_shopping_carts_on_device_id"
  end

  add_foreign_key "items", "shopping_carts"
  add_foreign_key "shopping_carts", "devices"
end
