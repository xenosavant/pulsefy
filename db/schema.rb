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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130620011441) do

  create_table "assemblies", :force => true do |t|
    t.string   "title"
    t.string   "info"
    t.string   "avatar"
    t.integer  "founder"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "assemblies_nodes", :id => false, :force => true do |t|
    t.integer "assembly_id"
    t.integer "node_id"
  end

  create_table "assemblies_pulses", :id => false, :force => true do |t|
    t.integer "assembly_id"
    t.integer "pulse_id"
  end

  create_table "connectors", :force => true do |t|
    t.integer  "input_id"
    t.integer  "output_id"
    t.float    "strength"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "connectors", ["input_id", "output_id"], :name => "index_connectors_on_input_id_and_output_id", :unique => true
  add_index "connectors", ["input_id"], :name => "index_connectors_on_input_id"
  add_index "connectors", ["output_id"], :name => "index_connectors_on_output_id"

  create_table "inboxes", :force => true do |t|
    t.integer  "node_id_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "inbox_id_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "nodes", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "info"
    t.string   "remember_token"
    t.string   "avatar"
    t.boolean  "admin"
    t.string   "password_digest"
    t.float    "threshold"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "nodes", ["email"], :name => "index_nodes_on_email", :unique => true

  create_table "nodes_pulses", :id => false, :force => true do |t|
    t.integer "node_id"
    t.integer "pulse_id"
  end

  create_table "pulse_comments", :force => true do |t|
    t.string   "content"
    t.integer  "commenter"
    t.integer  "pulse_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pulses", :force => true do |t|
    t.integer  "depth"
    t.integer  "reinforcements"
    t.integer  "degradations"
    t.integer  "pulser"
    t.integer  "pulse_comments_count", :default => 0
    t.string   "content"
    t.string   "pulser_type"
    t.string   "link"
    t.string   "tags"
    t.string   "embed_code"
    t.string   "thumbnail"
    t.string   "link_type"
    t.string   "url"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "pulses", ["pulser", "created_at"], :name => "index_pulses_on_pulser_and_created_at"

  create_table "votes", :force => true do |t|
    t.integer  "node_id"
    t.integer  "pulse_id"
    t.boolean  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
