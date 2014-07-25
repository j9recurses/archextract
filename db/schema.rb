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

ActiveRecord::Schema.define(version: 20140725022217) do

  create_table "collections", force: true do |t|
    t.string   "name"
    t.date     "acquisition_date"
    t.string   "acquisition_source"
    t.string   "src_datadir"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "isdir"
    t.boolean  "is_processed",       default: false, null: false
    t.string   "orig_upload_fn"
    t.string   "mimetype"
    t.integer  "filesize"
    t.string   "file_ext"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "delayed_workers", force: true do |t|
    t.string   "name"
    t.datetime "last_heartbeat_at"
  end

  add_index "delayed_workers", ["name"], name: "index_delayed_workers_on_name", unique: true, using: :btree

  create_table "extracts", force: true do |t|
    t.boolean  "lda"
    t.integer  "num_of_topics"
    t.boolean  "ner_people"
    t.boolean  "ner_organizations"
    t.boolean  "ner_places"
    t.boolean  "ner_dates"
    t.string   "routine_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id"
  end

  add_index "extracts", ["collection_id"], name: "index_extracts_on_collection_id", using: :btree

  create_table "preassignments", force: true do |t|
    t.integer "collection_id"
    t.integer "preprocesses_id"
  end

  add_index "preassignments", ["collection_id"], name: "index_preassignments_on_collection_id", using: :btree
  add_index "preassignments", ["preprocesses_id"], name: "index_preassignments_on_preprocesses_id", using: :btree

  create_table "preprocesses", force: true do |t|
    t.boolean  "stopwords"
    t.boolean  "rarewords"
    t.boolean  "stemmed"
    t.boolean  "tagged"
    t.string   "pos"
    t.boolean  "tagged_no_ner"
    t.boolean  "tfidf"
    t.string   "custom_stoplist"
    t.integer  "collection_id"
    t.string   "fname_base"
    t.string   "file_dir"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "routine_name"
    t.string   "status"
    t.boolean  "tfidf_btm"
    t.decimal  "tfidf_score",     precision: 10, scale: 0
  end

  add_index "preprocesses", ["collection_id"], name: "index_preprocesses_on_collection_id", using: :btree

end
