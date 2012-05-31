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

ActiveRecord::Schema.define(:version => 20120531174324) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "pub_key"
    t.boolean  "is_disabled", :default => false
  end

  add_index "accounts", ["pub_key"], :name => "index_accounts_on_pub_key", :unique => true
  add_index "accounts", ["subdomain"], :name => "index_accounts_on_subdomain", :unique => true

  create_table "catalog_items", :force => true do |t|
    t.string   "name"
    t.string   "part_number"
    t.string   "manufacturer"
    t.text     "description"
    t.float    "list_price"
    t.float    "cost"
    t.boolean  "is_recurring",             :default => false
    t.string   "recurring_unit"
    t.boolean  "is_taxable",               :default => false
    t.boolean  "is_subscription",          :default => false
    t.float    "subscription_length"
    t.string   "subscription_length_unit"
    t.string   "pub_key"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "account_key"
  end

  add_index "catalog_items", ["account_key"], :name => "index_catalog_items_on_account_key"

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.boolean  "is_draft",        :default => true
    t.string   "account_key"
    t.string   "creator_key"
    t.string   "opportunity_key"
    t.string   "pub_key"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "documents", ["account_key"], :name => "index_documents_on_account_key"
  add_index "documents", ["creator_key"], :name => "index_documents_on_creator_key"
  add_index "documents", ["pub_key"], :name => "index_documents_on_pub_key"

  create_table "members", :force => true do |t|
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "pub_key"
    t.string   "remember_token"
    t.string   "account_key"
    t.string   "user_key"
    t.boolean  "is_disabled",    :default => false
  end

  add_index "members", ["account_key", "user_key"], :name => "index_members_on_account_key_and_user_key"
  add_index "members", ["account_key"], :name => "index_members_on_account_key"
  add_index "members", ["pub_key"], :name => "index_members_on_pub_key", :unique => true
  add_index "members", ["remember_token"], :name => "index_members_on_remember_token"
  add_index "members", ["user_key"], :name => "index_members_on_user_key"

  create_table "opportunities", :force => true do |t|
    t.string   "name"
    t.date     "estimated_close"
    t.string   "milestone_key"
    t.float    "probability"
    t.string   "owner_key"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "account_key"
    t.string   "pub_key"
    t.string   "creator_key"
  end

  add_index "opportunities", ["account_key"], :name => "index_opportunities_on_account_key"
  add_index "opportunities", ["creator_key"], :name => "index_opportunities_on_creator_key"
  add_index "opportunities", ["pub_key"], :name => "index_opportunities_on_pub_key"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "pub_key"
    t.string   "password_digest"
    t.boolean  "is_disabled",     :default => false
  end

  add_index "users", ["pub_key"], :name => "index_users_on_pub_key", :unique => true

end
