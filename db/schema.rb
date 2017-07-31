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

ActiveRecord::Schema.define(version: 20170728114601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cash_operations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "comment"
    t.string   "operation"
    t.float    "sum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cash_operations_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_doc_requests", id: false, force: :cascade do |t|
    t.integer "doc_request_id", null: false
    t.integer "category_id",    null: false
    t.index ["category_id"], name: "index_categories_doc_requests_on_category_id", using: :btree
    t.index ["doc_request_id"], name: "index_categories_doc_requests_on_doc_request_id", using: :btree
  end

  create_table "categories_questions", id: false, force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_categories_questions_on_category_id", using: :btree
    t.index ["question_id"], name: "index_categories_questions_on_question_id", using: :btree
  end

  create_table "category_subscriptions", force: :cascade do |t|
    t.string   "timespan"
    t.float    "price"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_category_subscriptions_on_category_id", using: :btree
  end

  create_table "chat_messages", force: :cascade do |t|
    t.string   "sendable_type"
    t.integer  "sendable_id"
    t.string   "receivable_type"
    t.integer  "receivable_id"
    t.text     "text"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["receivable_type", "receivable_id"], name: "index_chat_messages_on_receivable_type_and_receivable_id", using: :btree
    t.index ["sendable_type", "sendable_id"], name: "index_chat_messages_on_sendable_type_and_sendable_id", using: :btree
  end

  create_table "chat_sessions", force: :cascade do |t|
    t.integer  "specialist_id"
    t.string   "clientable_type"
    t.integer  "clientable_id"
    t.boolean  "finished",          default: false
    t.string   "secret_chat_token"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["clientable_type", "clientable_id"], name: "index_chat_sessions_on_clientable_type_and_clientable_id", using: :btree
    t.index ["specialist_id"], name: "index_chat_sessions_on_specialist_id", using: :btree
  end

  create_table "chat_templates", force: :cascade do |t|
    t.string   "text"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chat_templates_on_user_id", using: :btree
  end

  create_table "citations", force: :cascade do |t|
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "kladr_code"
    t.string   "name"
    t.string   "kladr_type_short"
    t.string   "kladr_type"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "region_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["region_id"], name: "index_cities_on_region_id", using: :btree
  end

  create_table "cities_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "city_id", null: false
    t.index ["city_id"], name: "index_cities_users_on_city_id", using: :btree
    t.index ["user_id"], name: "index_cities_users_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "text"
    t.boolean  "delta",            default: true, null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "configurables", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "chat_sound_free"
    t.string   "chat_sound_paid"
    t.index ["name"], name: "index_configurables_on_name", using: :btree
  end

  create_table "doc_requests", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_doc_requests_on_user_id", using: :btree
  end

  create_table "doc_responses", force: :cascade do |t|
    t.boolean  "chosen"
    t.text     "text"
    t.integer  "user_id"
    t.integer  "doc_request_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "delta",          default: true, null: false
    t.datetime "check_date"
    t.datetime "complaint_date"
    t.index ["doc_request_id"], name: "index_doc_responses_on_doc_request_id", using: :btree
    t.index ["user_id"], name: "index_doc_responses_on_user_id", using: :btree
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text     "text"
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_feedbacks_on_user_id", using: :btree
  end

  create_table "file_containers", force: :cascade do |t|
    t.string   "file"
    t.string   "fileable_type"
    t.integer  "fileable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["fileable_type", "fileable_id"], name: "index_file_containers_on_fileable_type_and_fileable_id", using: :btree
  end

  create_table "guest_chat_tokens", force: :cascade do |t|
    t.string   "guest_chat_login"
    t.string   "guest_chat_password"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "ipranges", force: :cascade do |t|
    t.bigint   "ip_block_start"
    t.bigint   "ip_block_end"
    t.string   "ip_range"
    t.integer  "city_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["city_id"], name: "index_ipranges_on_city_id", using: :btree
  end

  create_table "lib_entries", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "lib_entry_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "file"
    t.jsonb    "data"
    t.index ["lib_entry_id"], name: "index_lib_entries_on_lib_entry_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.text     "text"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "read",            default: false
    t.boolean  "spam",            default: false
    t.boolean  "delta",           default: true,  null: false
    t.integer  "chat_session_id"
    t.index ["chat_session_id"], name: "index_messages_on_chat_session_id", using: :btree
    t.index ["recipient_id"], name: "index_messages_on_recipient_id", using: :btree
    t.index ["sender_id"], name: "index_messages_on_sender_id", using: :btree
  end

  create_table "metro_lines", force: :cascade do |t|
    t.string   "name"
    t.string   "hex_color"
    t.string   "metroable_type"
    t.integer  "metroable_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["metroable_type", "metroable_id"], name: "index_metro_lines_on_metroable_type_and_metroable_id", using: :btree
  end

  create_table "metro_stations", force: :cascade do |t|
    t.string   "name"
    t.string   "lat"
    t.string   "lng"
    t.integer  "metro_line_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["metro_line_id"], name: "index_metro_stations_on_metro_line_id", using: :btree
  end

  create_table "offers", force: :cascade do |t|
    t.float    "price"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "title"
    t.text     "text"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["recipient_id"], name: "index_offers_on_recipient_id", using: :btree
    t.index ["sender_id"], name: "index_offers_on_sender_id", using: :btree
  end

  create_table "payment_types", force: :cascade do |t|
    t.integer  "payment_id"
    t.string   "payable_type"
    t.integer  "payable_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["payable_type", "payable_id"], name: "index_payment_types_on_payable_type_and_payable_id", using: :btree
    t.index ["payment_id"], name: "index_payment_types_on_payment_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "comment"
    t.boolean  "cfrozen"
    t.string   "option"
    t.float    "sum"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["recipient_id"], name: "index_payments_on_recipient_id", using: :btree
    t.index ["sender_id"], name: "index_payments_on_sender_id", using: :btree
  end

  create_table "proposals", force: :cascade do |t|
    t.float    "price"
    t.integer  "user_id"
    t.string   "proposable_type"
    t.integer  "proposable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "text"
    t.integer  "limit_hours"
    t.integer  "limit_minutes"
    t.index ["proposable_type", "proposable_id"], name: "index_proposals_on_proposable_type_and_proposable_id", using: :btree
    t.index ["user_id"], name: "index_proposals_on_user_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "delta",      default: true,  null: false
    t.text     "text"
    t.boolean  "charged",    default: false
    t.index ["user_id"], name: "index_questions_on_user_id", using: :btree
  end

  create_table "regions", force: :cascade do |t|
    t.string   "kladr_code"
    t.string   "name"
    t.string   "kladr_type_short"
    t.string   "kladr_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.json     "tokens"
    t.string   "first_name"
    t.boolean  "active"
    t.string   "last_name"
    t.string   "middle_name"
    t.boolean  "email_public"
    t.string   "phone"
    t.integer  "experience"
    t.boolean  "qualification"
    t.float    "price"
    t.string   "university"
    t.string   "faculty"
    t.date     "dob_issue"
    t.string   "work"
    t.string   "staff"
    t.date     "dob"
    t.float    "balance"
    t.boolean  "online",                 default: false
    t.string   "avatar"
    t.datetime "online_time"
    t.string   "login"
    t.string   "fax"
    t.jsonb    "userdata"
    t.jsonb    "extends"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["login"], name: "index_users_on_login", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

end
