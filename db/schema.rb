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

ActiveRecord::Schema.define(version: 20150429094357) do

  create_table "collections", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.date     "acquisition_date"
    t.string   "acquisition_source", limit: 255
    t.string   "src_datadir",        limit: 255
    t.text     "notes",              limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_processed",       limit: 1,     default: false, null: false
    t.string   "status",             limit: 255
    t.string   "lib_path",           limit: 255
    t.string   "libserver",          limit: 255
    t.string   "slug",               limit: 255
  end

  add_index "collections", ["slug"], name: "index_collections_on_slug", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "delayed_workers", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "last_heartbeat_at"
  end

  add_index "delayed_workers", ["name"], name: "index_delayed_workers_on_name", unique: true, using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "file_dir",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id", limit: 4
    t.string   "filetype",      limit: 255
    t.boolean  "downloaded",    limit: 1
    t.string   "slug",          limit: 255
  end

  add_index "documents", ["collection_id"], name: "index_documents_on_collection_id", using: :btree
  add_index "documents", ["slug"], name: "index_documents_on_slug", using: :btree

  create_table "extract_ners", force: :cascade do |t|
    t.string   "status",        limit: 255
    t.string   "fname_base",    limit: 255
    t.string   "file_dir",      limit: 255
    t.boolean  "ner_peeps",     limit: 1
    t.boolean  "ner_places",    limit: 1
    t.boolean  "ner_orgs",      limit: 1
    t.boolean  "ner_dates",     limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id", limit: 4
    t.boolean  "keywords",      limit: 1
  end

  add_index "extract_ners", ["collection_id"], name: "index_extract_ners_on_collection_id", using: :btree

  create_table "extract_topics", force: :cascade do |t|
    t.boolean  "lda",           limit: 1
    t.integer  "num_of_topics", limit: 4
    t.string   "routine_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id", limit: 4
    t.integer  "preprocess_id", limit: 4
    t.string   "status",        limit: 255
    t.string   "fname_base",    limit: 255
    t.string   "file_dir",      limit: 255
  end

  add_index "extract_topics", ["collection_id"], name: "index_extract_topics_on_collection_id", using: :btree
  add_index "extract_topics", ["preprocess_id"], name: "index_extract_topics_on_preprocess_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "ners", force: :cascade do |t|
    t.string   "nertype",        limit: 255
    t.string   "name",           limit: 255
    t.text     "docs",           limit: 65535
    t.integer  "count",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id",  limit: 4
    t.integer  "extract_ner_id", limit: 4
    t.text     "sm_items",       limit: 65535
    t.integer  "sm_ct",          limit: 4
  end

  add_index "ners", ["collection_id"], name: "index_ners_on_collection_id", using: :btree
  add_index "ners", ["extract_ner_id"], name: "index_ners_on_extract_ner_id", using: :btree

  create_table "preassignments", force: :cascade do |t|
    t.integer "collection_id",   limit: 4
    t.integer "preprocesses_id", limit: 4
  end

  add_index "preassignments", ["collection_id"], name: "index_preassignments_on_collection_id", using: :btree
  add_index "preassignments", ["preprocesses_id"], name: "index_preassignments_on_preprocesses_id", using: :btree

  create_table "preprocesses", force: :cascade do |t|
    t.boolean  "stopwords",       limit: 1
    t.boolean  "rarewords",       limit: 1
    t.boolean  "stemmed",         limit: 1
    t.boolean  "tagged",          limit: 1
    t.string   "pos",             limit: 255
    t.boolean  "tagged_no_ner",   limit: 1
    t.boolean  "tfidf",           limit: 1
    t.string   "custom_stoplist", limit: 255
    t.integer  "collection_id",   limit: 4
    t.string   "fname_base",      limit: 255
    t.string   "file_dir",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "routine_name",    limit: 255
    t.string   "status",          limit: 255
    t.boolean  "tfidf_btm",       limit: 1
    t.float    "tfidf_score",     limit: 24,  default: 0.0
  end

  add_index "preprocesses", ["collection_id"], name: "index_preprocesses_on_collection_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "topic_doc_names", force: :cascade do |t|
    t.text "name", limit: 65535
  end

  create_table "topic_docs", id: false, force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "topics",             limit: 4294967295
    t.text     "topic_vals",         limit: 4294967295
    t.integer  "dcid",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id",      limit: 4
    t.integer  "preprocess_id",      limit: 4
    t.integer  "extract_topic_id",   limit: 4
    t.integer  "doc_topic_names_id", limit: 4
  end

  add_index "topic_docs", ["collection_id"], name: "index_topic_docs_on_collection_id", using: :btree
  add_index "topic_docs", ["doc_topic_names_id"], name: "index_topic_docs_on_doc_topic_names_id", using: :btree
  add_index "topic_docs", ["extract_topic_id"], name: "index_topic_docs_on_extract_topic_id", using: :btree
  add_index "topic_docs", ["preprocess_id"], name: "index_topic_docs_on_preprocess_id", using: :btree

  create_table "topic_names", force: :cascade do |t|
    t.text "name", limit: 65535
  end

  create_table "topics", id: false, force: :cascade do |t|
    t.text     "name",             limit: 65535
    t.text     "docs",             limit: 4294967295
    t.text     "doc_vals",         limit: 4294967295
    t.integer  "tid",              limit: 4
    t.string   "topic_number",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id",    limit: 4
    t.integer  "preprocess_id",    limit: 4
    t.integer  "extract_topic_id", limit: 4
    t.integer  "topic_names_id",   limit: 4
  end

  add_index "topics", ["collection_id"], name: "index_topics_on_collection_id", using: :btree
  add_index "topics", ["extract_topic_id"], name: "index_topics_on_extract_topic_id", using: :btree
  add_index "topics", ["preprocess_id"], name: "index_topics_on_preprocess_id", using: :btree
  add_index "topics", ["topic_names_id"], name: "index_topics_on_topic_names_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.integer  "perms_level",            limit: 4
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archivist",              limit: 1
    t.boolean  "researcher",             limit: 1
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
