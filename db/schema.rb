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

ActiveRecord::Schema.define(version: 2020_09_06_072701) do

  create_table "db_shohins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "shohin_mei", null: false
    t.string "shohin_bunrui", null: false
    t.integer "hanbai_tanka"
    t.integer "shiire_tanka"
    t.date "torokubi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "samplelikes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "strcol", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "samplemaths", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "m", precision: 10
    t.integer "n"
    t.integer "p"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "samplestrs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "str1", limit: 40
    t.string "str2", limit: 40
    t.string "str3", limit: 40
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tenposhohins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "shohin_id", null: false
    t.string "code", null: false
    t.string "tenpo_mei", null: false
    t.integer "suryo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
