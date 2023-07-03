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

ActiveRecord::Schema.define(version: 20230628083421) do

  create_table "accounts", force: :cascade do |t|
    t.string   "account_number"
    t.integer  "account_type"
    t.float    "balance"
    t.integer  "customer_id"
    t.datetime "created_at"
  end

  create_table "addresses", force: :cascade do |t|
    t.string  "address1"
    t.string  "district"
    t.string  "state"
    t.string  "country"
    t.integer "postal_code"
    t.integer "customer_id"
  end

  create_table "atm_cards", force: :cascade do |t|
    t.string   "card_number"
    t.integer  "cvv"
    t.string   "expiry_date"
    t.string   "account_number"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "loan_account_infos", force: :cascade do |t|
    t.integer  "loan_type"
    t.integer  "duration"
    t.integer  "amount"
    t.string   "account_number"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.float    "amount"
    t.string   "account_number"
    t.integer  "transaction_type"
    t.float    "current_balance"
    t.string   "account_related"
    t.datetime "created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "name"
    t.string   "email"
    t.string   "mobile"
    t.integer  "customer_id"
    t.date     "dob"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
