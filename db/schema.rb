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

ActiveRecord::Schema[7.0].define(version: 2022_10_25_224900) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "phone"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.text "sipips"
    t.text "webips"
  end

  create_table "agents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "hotline_id", null: false
    t.bigint "exten_id", null: false
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "membername"
    t.string "queue_name"
    t.string "interface"
    t.integer "paused", default: 0
    t.integer "uniqueid"
    t.index ["account_id"], name: "index_agents_on_account_id"
    t.index ["exten_id"], name: "index_agents_on_exten_id"
    t.index ["hotline_id"], name: "index_agents_on_hotline_id"
  end

  create_table "cdrs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "accountcode"
    t.string "src"
    t.string "dst"
    t.string "dcontext"
    t.string "clid"
    t.string "channel"
    t.string "dstchannel"
    t.string "lastapp"
    t.string "lastdata"
    t.datetime "start"
    t.datetime "answer"
    t.datetime "end"
    t.integer "duration"
    t.integer "billsec"
    t.string "disposition"
    t.string "amaflags"
    t.string "userfield"
    t.string "uniqueid"
    t.string "linkedid"
    t.string "peeraccount"
    t.integer "sequence"
    t.index ["accountcode", "created_at"], name: "index_cdrs_on_accountcode_and_created_at"
    t.index ["accountcode"], name: "index_cdrs_on_accountcode"
    t.index ["created_at"], name: "index_cdrs_on_created_at"
  end

  create_table "extens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "exten"
    t.string "secret"
    t.string "name"
    t.string "decription"
    t.bigint "account_id", null: false
    t.bigint "sip_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "calllimit", default: 1
    t.string "record", default: "No"
    t.index ["account_id", "exten"], name: "index_extens_on_account_id_and_exten", unique: true
    t.index ["account_id"], name: "index_extens_on_account_id"
    t.index ["sip_id"], name: "index_extens_on_sip_id"
  end

  create_table "hotlines", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "strategy"
    t.integer "timeout"
    t.integer "retry"
    t.integer "wrapuptime"
    t.integer "maxlen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.string "musiconhold"
    t.string "announce"
    t.string "context"
    t.integer "monitor_join"
    t.string "monitor_format"
    t.string "queue_youarenext"
    t.string "queue_thereare"
    t.string "queue_callswaiting"
    t.string "queue_holdtime"
    t.string "queue_minutes"
    t.string "queue_seconds"
    t.string "queue_lessthan"
    t.string "queue_thankyou"
    t.string "queue_reporthold"
    t.integer "announce_frequency"
    t.integer "announce_round_seconds"
    t.string "announce_holdtime"
    t.integer "servicelevel"
    t.string "joinempty"
    t.string "leavewhenempty"
    t.string "eventmemberstatus"
    t.string "eventwhencalled"
    t.integer "reportholdtime"
    t.integer "memberdelay"
    t.integer "weight"
    t.integer "timeoutrestart"
    t.string "periodic_announce"
    t.integer "periodic_announce_frequency"
    t.integer "ringinuse"
    t.string "setinterfacevar"
    t.bigint "moh_id"
    t.integer "maxtime", default: 0
    t.index ["account_id", "title"], name: "index_hotlines_on_account_id_and_title", unique: true
    t.index ["account_id"], name: "index_hotlines_on_account_id"
    t.index ["moh_id"], name: "index_hotlines_on_moh_id"
    t.index ["name"], name: "index_hotlines_on_name"
  end

  create_table "logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "event"
    t.text "data"
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "ipaddr"
    t.index ["account_id"], name: "index_logs_on_account_id"
    t.index ["created_at"], name: "index_logs_on_created_at"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "from", default: "System"
    t.text "message"
    t.integer "read", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.string "messagetype", default: "Info"
    t.index ["account_id"], name: "index_messages_on_account_id"
  end

  create_table "moh_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "moh_id", null: false
    t.bigint "sound_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_moh_entries_on_account_id"
    t.index ["moh_id"], name: "index_moh_entries_on_moh_id"
    t.index ["sound_id"], name: "index_moh_entries_on_sound_id"
  end

  create_table "mohs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.index ["account_id", "name"], name: "index_mohs_on_account_id_and_name", unique: true
    t.index ["account_id"], name: "index_mohs_on_account_id"
  end

  create_table "routes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "record", default: "No", null: false
    t.date "day"
    t.string "daystart", default: "mon", null: false
    t.string "daystop", default: "sun", null: false
    t.integer "hourstart", default: 0, null: false
    t.integer "hourstop", default: 23, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.bigint "sip_id", null: false
    t.index ["account_id"], name: "index_routes_on_account_id"
    t.index ["sip_id"], name: "index_routes_on_sip_id"
  end

  create_table "sips", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "sipid"
    t.string "secret"
    t.string "host"
    t.string "number"
    t.string "decription"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.index ["account_id", "number"], name: "index_sips_on_account_id_and_number", unique: true
    t.index ["account_id", "sipid"], name: "index_sips_on_account_id_and_sipid", unique: true
    t.index ["account_id"], name: "index_sips_on_account_id"
  end

  create_table "sounds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "audio"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "converted", default: 0
    t.index ["account_id", "name"], name: "index_sounds_on_account_id_and_name", unique: true
    t.index ["account_id"], name: "index_sounds_on_account_id"
  end

  create_table "steps", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "event"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.bigint "route_id", null: false
    t.integer "stepnum", default: 9999
    t.index ["account_id"], name: "index_steps_on_account_id"
    t.index ["route_id"], name: "index_steps_on_route_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.bigint "account_id", null: false
    t.string "firstname"
    t.string "lastname"
    t.string "image"
    t.text "permission"
    t.integer "isadmin", default: 0
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "voicemails", primary_key: "uniqueid", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "context", default: ""
    t.integer "mailbox", default: 0
    t.string "password", default: "9999"
    t.string "fullname", default: "0"
    t.string "email", default: ""
    t.string "pager", default: ""
    t.datetime "stamp"
    t.string "attach", default: "No"
    t.string "saycid", default: "Yes"
    t.string "hidefromdir", default: "No"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exten_id", null: false
    t.index ["exten_id"], name: "index_voicemails_on_exten_id"
  end

  add_foreign_key "agents", "accounts"
  add_foreign_key "agents", "extens"
  add_foreign_key "agents", "hotlines"
  add_foreign_key "extens", "accounts"
  add_foreign_key "extens", "sips"
  add_foreign_key "hotlines", "accounts"
  add_foreign_key "logs", "accounts"
  add_foreign_key "logs", "users"
  add_foreign_key "messages", "accounts"
  add_foreign_key "moh_entries", "accounts"
  add_foreign_key "moh_entries", "mohs"
  add_foreign_key "moh_entries", "sounds"
  add_foreign_key "mohs", "accounts"
  add_foreign_key "routes", "accounts"
  add_foreign_key "routes", "sips"
  add_foreign_key "sips", "accounts"
  add_foreign_key "sounds", "accounts"
  add_foreign_key "steps", "accounts"
  add_foreign_key "steps", "routes"
  add_foreign_key "users", "accounts"
  add_foreign_key "voicemails", "extens"
end
