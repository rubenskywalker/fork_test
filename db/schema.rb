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

ActiveRecord::Schema.define(:version => 20131209133500) do

  create_table "attach_contacts", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "transaction_id"
    t.integer  "role_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "user_id"
  end

  create_table "checklist_item_masters", :force => true do |t|
    t.integer  "checklist_master_id"
    t.string   "name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "position"
  end

  create_table "checklist_items", :force => true do |t|
    t.integer  "checklist_id"
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "checked"
    t.integer  "position"
  end

  create_table "checklist_masters", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "lock",       :default => false
    t.integer  "company_id"
    t.integer  "position"
  end

  create_table "checklist_masters_transaction_types", :id => false, :force => true do |t|
    t.integer "checklist_master_id"
    t.integer "transaction_type_id"
  end

  create_table "checklist_permissions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "checklists", :force => true do |t|
    t.string   "name"
    t.integer  "transaction_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "checklist_master_id"
    t.boolean  "completed"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "plan_name",             :default => "Trial"
    t.boolean  "trial",                 :default => true
    t.integer  "price_per_user"
    t.integer  "price_per_transaction"
    t.integer  "trial_days",            :default => 30
    t.integer  "transactions_included", :default => 5
    t.integer  "users_included",        :default => 0
    t.integer  "monthly_fee"
    t.string   "stripe_card_token"
    t.string   "card_four"
    t.boolean  "switch_plan",           :default => false
    t.boolean  "is_lock",               :default => false
  end

  create_table "company_invites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contact_accesses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "transaction_id"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "email"
    t.string   "company"
    t.text     "info"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "fax"
    t.integer  "role_id"
  end

  create_table "dashboards", :force => true do |t|
    t.boolean  "transactions_summary"
    t.boolean  "transactions_alosing"
    t.boolean  "transaction_added"
    t.boolean  "transactions_past"
    t.boolean  "recent_activity"
    t.boolean  "listings"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "user_id"
  end

  create_table "default_plans", :force => true do |t|
    t.string  "plan_name"
    t.boolean "trial"
    t.integer "price_per_user"
    t.integer "price_per_transaction"
    t.integer "trial_days"
    t.integer "integer"
    t.integer "transactions_included"
    t.integer "users_included"
    t.integer "monthly_fee"
  end

  create_table "doc_accesses", :force => true do |t|
    t.integer  "doc_id"
    t.integer  "docable_id"
    t.string   "docable_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "moved"
  end

  create_table "docs", :force => true do |t|
    t.string   "file"
    t.integer  "user_id"
    t.string   "docable_type"
    t.integer  "docable_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "counter",        :default => 1
    t.boolean  "review"
    t.boolean  "users_assigned"
    t.boolean  "by_mail"
    t.string   "secret_key"
    t.string   "alias"
    t.boolean  "incompatible",   :default => false
  end

  create_table "docs_users", :id => false, :force => true do |t|
    t.integer "doc_id"
    t.integer "user_id"
  end

  add_index "docs_users", ["doc_id", "user_id"], :name => "index_docs_users_on_doc_id_and_user_id"
  add_index "docs_users", ["user_id", "doc_id"], :name => "index_docs_users_on_user_id_and_doc_id"

  create_table "general_permissions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "libraries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.boolean  "main"
    t.boolean  "is_default"
    t.integer  "sorting",    :default => 0
    t.integer  "company_id"
  end

  create_table "location_permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.boolean  "l1"
    t.boolean  "l2"
    t.boolean  "l3"
    t.boolean  "l4"
    t.boolean  "l5"
    t.boolean  "l6"
    t.boolean  "l7"
    t.boolean  "l8"
    t.boolean  "l9"
    t.boolean  "l10"
    t.boolean  "l11"
    t.boolean  "l12"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "l13"
    t.boolean  "l14"
    t.boolean  "l15"
    t.boolean  "l16"
    t.boolean  "l17"
    t.boolean  "l18"
  end

  create_table "locations", :force => true do |t|
    t.integer  "transacrion_id"
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "company_id"
  end

  create_table "mail_templates", :force => true do |t|
    t.text     "category"
    t.text     "body"
    t.string   "subject"
    t.text     "variables_list"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "mail_texts", :force => true do |t|
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notes", :force => true do |t|
    t.integer  "transaction_id"
    t.integer  "checklist_id"
    t.integer  "user_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "complete_items"
    t.boolean  "incomplete_items"
    t.text     "status"
    t.boolean  "by_mail"
    t.string   "for_users",        :default => ""
  end

  create_table "payment_items", :force => true do |t|
    t.string   "itemable_type"
    t.integer  "itemable_id"
    t.integer  "company_id"
    t.datetime "deleted_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "png_docs", :force => true do |t|
    t.integer  "doc_id"
    t.string   "file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "recent_activities", :force => true do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "transaction_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "note_id"
  end

  create_table "roles", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "level"
    t.integer  "sorting"
  end

  create_table "transaction_details", :force => true do |t|
    t.boolean  "l1"
    t.integer  "l1n"
    t.integer  "address_1"
    t.integer  "address_2"
    t.integer  "city"
    t.integer  "state"
    t.integer  "zip"
    t.integer  "mls"
    t.integer  "close_date"
    t.integer  "expiration_date"
    t.integer  "list_price"
    t.integer  "ba_commision"
    t.integer  "la_commision"
    t.integer  "commision_note"
    t.integer  "transaction_format"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "auto_lock"
    t.integer  "offer"
    t.integer  "pending"
    t.integer  "listing"
    t.integer  "sale_price"
    t.integer  "what_role"
    t.integer  "company_id"
    t.integer  "t_status"
    t.integer  "t_type"
    t.integer  "county",             :default => 0
    t.integer  "acceptance_date",    :default => 0
    t.boolean  "only_pdf",           :default => false
  end

  create_table "transaction_statuses", :force => true do |t|
    t.integer  "transaction_detail_id"
    t.string   "name"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "checked"
    t.boolean  "sub_category",          :default => false
    t.string   "category"
  end

  create_table "transaction_types", :force => true do |t|
    t.integer  "transaction_detail_id"
    t.string   "name"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.boolean  "checked"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "mls"
    t.string   "street"
    t.string   "city"
    t.string   "status"
    t.date     "close_sate"
    t.string   "file"
    t.integer  "transaction_type_id"
    t.boolean  "lock"
    t.integer  "user_status"
    t.boolean  "user_status_1"
    t.boolean  "user_status_2"
    t.boolean  "user_status_3"
    t.string   "address_1"
    t.string   "address_2"
    t.date     "expiration_date"
    t.integer  "list_price"
    t.integer  "sale_price"
    t.string   "state"
    t.integer  "transaction_status_id"
    t.integer  "ba_commision"
    t.integer  "la_commision"
    t.text     "commision_note"
    t.integer  "location_id"
    t.integer  "company_id"
    t.string   "zip"
    t.string   "county"
    t.date     "acceptance_date"
  end

  create_table "user_permissions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",     :null => false
    t.string   "encrypted_password",     :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "name"
    t.integer  "role_id"
    t.text     "info"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "fax"
    t.boolean  "contact_only"
    t.boolean  "super_admin",            :default => false
    t.boolean  "p_all",                  :default => false
    t.boolean  "p_master",               :default => false
    t.boolean  "p_library",              :default => false
    t.integer  "parent_id"
    t.boolean  "send_welcome"
    t.string   "welcome_subject"
    t.text     "welcome_message"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.integer  "transaction_count",      :default => 1
    t.boolean  "accept_users",           :default => false
    t.boolean  "extra_admin"
    t.integer  "company_id"
    t.string   "plan",                   :default => "none"
    t.string   "contact_company"
    t.string   "avatar"
    t.boolean  "is_locked"
    t.boolean  "no_email"
    t.boolean  "is_guest"
    t.string   "mail_digest"
    t.text     "dropbox_code"
    t.datetime "last_dropbox_backup"
    t.string   "dropbox_cursor"
    t.date     "confirmed_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "welcome_templates", :force => true do |t|
    t.string   "name"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "widgets", :force => true do |t|
    t.integer  "dashboard_id"
    t.string   "widget_type"
    t.date     "widget_date"
    t.integer  "location_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "user_id"
    t.string   "month_name"
    t.integer  "closing_in"
    t.integer  "position"
    t.string   "ra_for"
    t.boolean  "myself",       :default => false
  end

end
