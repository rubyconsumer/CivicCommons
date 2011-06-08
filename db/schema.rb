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

ActiveRecord::Schema.define(:version => 20110529110500) do

  create_table "achievement_earneds", :force => true do |t|
    t.integer  "person_id"
    t.integer  "achievement_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "achievement_metadatas", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "points"
    t.integer  "threshold"
    t.string   "badge_file_name"
    t.string   "badge_content_type"
    t.integer  "badge_file_size"
    t.datetime "badge_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "achievement_statistics", :force => true do |t|
    t.integer  "person_id"
    t.integer  "achievement_metadata_id"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.text     "description"
    t.string   "link"
    t.string   "video_url"
    t.string   "percent"
    t.boolean  "current",                              :default => false
    t.boolean  "main",                                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "homepage_article",                     :default => false
    t.boolean  "issue_article",                        :default => false
    t.boolean  "conversation_article",                 :default => false
    t.string   "embed_target",         :limit => 1000
    t.string   "youtube_id"
  end

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["person_id"], :name => "index_authentications_on_person_id"
  add_index "authentications", ["provider"], :name => "index_authentications_on_provider"
  add_index "authentications", ["uid"], :name => "index_authentications_on_uid"

  create_table "content_items", :force => true do |t|
    t.integer  "person_id"
    t.string   "content_type"
    t.string   "title",           :null => false
    t.text     "summary"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.datetime "published"
    t.text     "embed_code"
    t.string   "external_link"
    t.integer  "conversation_id"
  end

  add_index "content_items", ["cached_slug"], :name => "index_content_items_on_cached_slug", :unique => true

  create_table "content_templates", :force => true do |t|
    t.string   "name"
    t.text     "template"
    t.integer  "person_id"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stylesheet_path"
  end

  add_index "content_templates", ["cached_slug"], :name => "index_content_templates_on_cached_slug", :unique => true

  create_table "contributions", :force => true do |t|
    t.datetime "datetime"
    t.integer  "owner"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "official",                                :default => false
    t.integer  "conversation_id"
    t.integer  "parent_id"
    t.integer  "issue_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "type",                                    :default => "Contribution"
    t.integer  "total_visits"
    t.integer  "recent_visits"
    t.integer  "total_rating"
    t.integer  "recent_rating"
    t.datetime "last_visit_date"
    t.datetime "last_rating_date"
    t.string   "askee"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.string   "embed_target",            :limit => 1000
    t.boolean  "confirmed",                               :default => true
    t.boolean  "notify"
    t.text     "embedly_code"
    t.string   "embedly_type"
  end

  create_table "conversations", :force => true do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "zip_code"
    t.integer  "total_visits",            :default => 0
    t.integer  "recent_visits",           :default => 0
    t.datetime "last_visit_date"
    t.integer  "total_rating"
    t.integer  "recent_rating"
    t.datetime "last_rating_date"
    t.string   "video_url"
    t.string   "audio_clip_file_name"
    t.string   "audio_clip_content_type"
    t.integer  "audio_clip_file_size"
    t.datetime "audio_clip_updated_at"
    t.integer  "owner"
    t.boolean  "staff_pick",              :default => false, :null => false
    t.integer  "position"
    t.boolean  "from_community",          :default => false
    t.string   "cached_slug"
  end

  add_index "conversations", ["cached_slug"], :name => "index_conversations_on_cached_slug", :unique => true

  create_table "conversations_events", :id => false, :force => true do |t|
    t.integer "conversation_id"
    t.integer "event_id"
  end

  create_table "conversations_guides", :id => false, :force => true do |t|
    t.integer "conversation_id"
    t.integer "guide_id"
  end

  create_table "conversations_issues", :id => false, :force => true do |t|
    t.integer "conversation_id"
    t.integer "issue_id"
  end

  create_table "counties", :force => true do |t|
    t.string   "name"
    t.string   "state",      :limit => 2
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "counties", ["region_id"], :name => "index_counties_on_region_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["locked_by"], :name => "delayed_jobs_locked_by"
  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "issues", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "summary"
    t.integer  "total_visits"
    t.integer  "recent_visits"
    t.integer  "total_rating"
    t.integer  "recent_rating"
    t.datetime "last_visit_date"
    t.datetime "last_rating_date"
    t.string   "zip_code"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "url"
    t.string   "url_title"
    t.string   "cached_slug"
    t.string   "type",                  :default => "Issue", :null => false
    t.integer  "managed_issue_page_id"
  end

  add_index "issues", ["cached_slug"], :name => "index_issues_on_cached_slug", :unique => true

  create_table "managed_issue_pages", :force => true do |t|
    t.string   "name",            :null => false
    t.integer  "issue_id",        :null => false
    t.integer  "person_id",       :null => false
    t.text     "template",        :null => false
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stylesheet_path"
  end

  add_index "managed_issue_pages", ["cached_slug"], :name => "index_managed_issue_pages_on_cached_slug", :unique => true
  add_index "managed_issue_pages", ["issue_id"], :name => "index_managed_issue_pages_on_issue_id"

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password"
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "zip_code"
    t.integer  "top"
    t.boolean  "proxy"
    t.boolean  "organization",                        :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "marketable"
    t.datetime "marketable_at"
    t.text     "bio"
    t.boolean  "daily_digest",                        :default => true,  :null => false
    t.boolean  "declined_fb_auth"
    t.string   "cached_slug"
    t.string   "twitter_username"
    t.string   "website"
  end

  add_index "people", ["cached_slug"], :name => "index_people_on_cached_slug", :unique => true
  add_index "people", ["email"], :name => "index_people_on_email", :unique => true
  add_index "people", ["reset_password_token"], :name => "index_people_on_reset_password_token", :unique => true

  create_table "rating_descriptors", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rating_groups", :force => true do |t|
    t.integer  "person_id"
    t.integer  "conversation_id"
    t.integer  "contribution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "rating_group_id"
    t.integer  "rating_descriptor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.text     "description"
  end

  create_table "revision_records", :force => true do |t|
    t.string   "revisionable_type", :limit => 100, :null => false
    t.integer  "revisionable_id",                  :null => false
    t.integer  "revision",                         :null => false
    t.binary   "data"
    t.datetime "created_at",                       :null => false
  end

  add_index "revision_records", ["revisionable_type", "revisionable_id", "revision"], :name => "revisionable", :unique => true

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "person_id"
    t.integer  "subscribable_id"
    t.string   "subscribable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["person_id", "subscribable_type", "subscribable_id"], :name => "unique-subs", :unique => true

  create_table "top_items", :force => true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "item_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conversation_id"
    t.integer  "issue_id"
    t.integer  "person_id"
    t.text     "activity_cache"
  end

  add_index "top_items", ["conversation_id"], :name => "conversations_index"
  add_index "top_items", ["issue_id"], :name => "issues_index"
  add_index "top_items", ["person_id"], :name => "person_index"

  create_table "visits", :force => true do |t|
    t.integer  "person_id"
    t.integer  "visitable_id"
    t.string   "visitable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zip_codes", :force => true do |t|
    t.integer  "region_id"
    t.string   "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
