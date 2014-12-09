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

ActiveRecord::Schema.define(version: 20141209081547) do

  create_table "specifications", force: true do |t|
    t.integer  "creater_id"
    t.string   "brand"
    t.string   "model"
    t.string   "pdf"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "specifications", ["creater_id"], name: "index_specifications_on_creater_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "e_mail"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
