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

ActiveRecord::Schema.define(version: 20150105191543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id",                 null: false
    t.text     "title",                       null: false
    t.boolean  "correct",     default: false, null: false
    t.integer  "position",                    null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "choices", force: :cascade do |t|
    t.integer  "entry_id",   null: false
    t.integer  "answer_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "choices", ["answer_id"], name: "index_choices_on_answer_id", using: :btree
  add_index "choices", ["entry_id"], name: "index_choices_on_entry_id", using: :btree

  create_table "entries", force: :cascade do |t|
    t.integer  "take_id",     null: false
    t.integer  "question_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "entries", ["question_id"], name: "index_entries_on_question_id", using: :btree
  add_index "entries", ["take_id"], name: "index_entries_on_take_id", using: :btree

  create_table "guests", force: :cascade do |t|
    t.string   "token",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "guests", ["token"], name: "index_guests_on_token", unique: true, using: :btree

  create_table "questionnaires", force: :cascade do |t|
    t.integer  "guest_id",                    null: false
    t.string   "token",                       null: false
    t.string   "name",                        null: false
    t.float    "points_for_correct_answer"
    t.float    "points_for_incorrect_answer"
    t.datetime "published_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "questionnaires", ["guest_id"], name: "index_questionnaires_on_guest_id", using: :btree
  add_index "questionnaires", ["token"], name: "index_questionnaires_on_token", unique: true, using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "questionnaire_id", null: false
    t.text     "title",            null: false
    t.integer  "position",         null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "questions", ["questionnaire_id"], name: "index_questions_on_questionnaire_id", using: :btree

  create_table "takes", force: :cascade do |t|
    t.integer  "guest_id",         null: false
    t.integer  "questionnaire_id", null: false
    t.string   "name",             null: false
    t.datetime "finished_at"
    t.float    "score"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "takes", ["guest_id"], name: "index_takes_on_guest_id", using: :btree
  add_index "takes", ["questionnaire_id"], name: "index_takes_on_questionnaire_id", using: :btree

  add_foreign_key "answers", "questions"
  add_foreign_key "choices", "answers"
  add_foreign_key "choices", "entries"
  add_foreign_key "entries", "questions"
  add_foreign_key "entries", "takes"
  add_foreign_key "questionnaires", "guests"
  add_foreign_key "questions", "questionnaires"
  add_foreign_key "takes", "guests"
  add_foreign_key "takes", "questionnaires"
end
