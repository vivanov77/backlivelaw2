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

ActiveRecord::Schema.define(version: 20170324141013) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "doc_requests", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.boolean  "paid"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_doc_requests_on_user_id", using: :btree
  end

  create_table "doc_responses", force: :cascade do |t|
    t.boolean  "chosen"
    t.text     "text"
    t.float    "price"
    t.integer  "user_id"
    t.integer  "doc_request_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["doc_request_id"], name: "index_doc_responses_on_doc_request_id", using: :btree
    t.index ["user_id"], name: "index_doc_responses_on_user_id", using: :btree
  end

  create_table "file_containers", force: :cascade do |t|
    t.string   "file"
    t.string   "fileable_type"
    t.integer  "fileable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["fileable_type", "fileable_id"], name: "index_file_containers_on_fileable_type_and_fileable_id", using: :btree
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
    t.index ["lib_entry_id"], name: "index_lib_entries_on_lib_entry_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.text     "text"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["recipient_id"], name: "index_messages_on_recipient_id", using: :btree
    t.index ["sender_id"], name: "index_messages_on_sender_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "delta",      default: true, null: false
    t.text     "text"
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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

end
