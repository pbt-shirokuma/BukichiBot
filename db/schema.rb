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

ActiveRecord::Schema.define(version: 2019_07_25_042735) do

  create_table "fest_votes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "fest_id", null: false
    t.bigint "user_id", null: false
    t.string "selection", null: false
    t.integer "game_count", default: 0
    t.integer "win_count", default: 0
    t.decimal "win_rate", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fest_id", "user_id", "created_at"], name: "index_fest_votes_on_fest_id_and_user_id_and_created_at"
    t.index ["fest_id"], name: "index_fest_votes_on_fest_id"
    t.index ["user_id"], name: "index_fest_votes_on_user_id"
  end

  create_table "fests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "fest_name", null: false
    t.string "fest_status", default: "00"
    t.string "fest_image"
    t.string "selection_a", null: false
    t.string "selection_b", null: false
    t.string "fest_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_fests_on_created_at"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "message_id"
    t.string "message_type"
    t.text "request"
    t.text "response"
    t.text "reply_response"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_messages_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "line_id", null: false
    t.string "status", default: "00", null: false
    t.string "talk_status", default: "00"
    t.boolean "del_flg", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_users_on_created_at"
  end

end
