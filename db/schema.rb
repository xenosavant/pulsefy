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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140225194332) do

  create_table "assemblies", :force => true do |t|
    t.string   "title"
    t.string   "avatar"
    t.text     "info"
    t.integer  "founder"
    t.float    "crop_x"
    t.float    "crop_y"
    t.float    "crop_w"
    t.float    "crop_h"
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

  create_table "convos", :force => true do |t|
    t.integer  "dialogue_id"
    t.integer  "interrogator_id"
    t.integer  "interlocutor_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "convos", ["dialogue_id"], :name => "index_convos_on_dialogue_id"

  create_table "dialogues", :force => true do |t|
    t.integer  "node_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "dialogues", ["receiver_id"], :name => "index_dialogues_on_receiver_id"

  create_table "messages", :force => true do |t|
    t.integer  "convo_id"
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.string   "content"
    t.boolean  "read"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "messages", ["convo_id"], :name => "index_messages_on_convo_id"

  create_table "nodes", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "remember_token"
    t.string   "avatar"
    t.text     "info"
    t.boolean  "admin"
    t.boolean  "hub"
    t.boolean  "verified"
    t.string   "password_digest"
    t.string   "self_tag"
    t.float    "threshold"
    t.float    "crop_x"
    t.float    "crop_y"
    t.float    "crop_w"
    t.float    "crop_h"
    t.float    "width"
    t.float    "height"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "nodes", ["email"], :name => "index_nodes_on_email", :unique => true
  add_index "nodes", ["self_tag"], :name => "index_nodes_on_self_tag", :unique => true

  create_table "nodes_pulses", :id => false, :force => true do |t|
    t.integer "node_id"
    t.integer "pulse_id"
  end

  create_table "pulse_comments", :force => true do |t|
    t.text     "content"
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
    t.integer  "refires"
    t.integer  "pulse_comments_count", :default => 0
    t.string   "pulser_type"
    t.string   "tags"
    t.string   "headline"
    t.text     "link_type"
    t.text     "embed_code"
    t.text     "link"
    t.text     "content"
    t.text     "url"
    t.text     "thumbnail"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "pulses", ["pulser", "created_at"], :name => "index_pulses_on_pulser_and_created_at"

  create_table "repulses", :force => true do |t|
    t.integer  "node_id"
    t.integer  "pulse_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "node_id"
    t.integer  "pulse_id"
    t.boolean  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
