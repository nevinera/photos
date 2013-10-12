# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131012172728) do

  create_table "admins", force: true do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true

  create_table "galleries", force: true do |t|
    t.string   "name"
    t.string   "client"
    t.date     "date"
    t.text     "notes"
    t.string   "original_name"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from_directory"
    t.string   "state",          default: "waiting"
  end

  add_index "galleries", ["date"], name: "index_galleries_on_date"
  add_index "galleries", ["secret"], name: "index_galleries_on_secret", unique: true

end
