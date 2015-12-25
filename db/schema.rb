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

ActiveRecord::Schema.define(:version => 20151220234606) do

  create_table "actions", :force => true do |t|
    t.string   "kind",         :limit => nil
    t.integer  "repo_id"
    t.string   "container_id", :limit => nil
    t.integer  "task_id"
    t.integer  "github_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "github_url",   :limit => nil
    t.integer  "user_id"
    t.string   "title",        :limit => nil
    t.text     "body"
  end

  add_index "actions", ["repo_id"], :name => "index_actions_on_repo_id"
  add_index "actions", ["task_id"], :name => "index_actions_on_task_id"

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "behaviors", :force => true do |t|
    t.string  "kind",        :limit => nil
    t.string  "name",        :limit => nil
    t.string  "tone",        :limit => nil
    t.string  "discovers",   :limit => nil
    t.string  "image",       :limit => nil
    t.text    "description"
    t.boolean "active"
    t.string  "triggers",    :limit => nil, :default => "{}"
    t.string  "actions",     :limit => nil, :default => "{}"
    t.string  "files",       :limit => nil, :default => "{}"
    t.string  "tags",        :limit => nil, :default => "{}"
  end

  add_index "behaviors", ["kind"], :name => "index_behaviors_on_kind"

  create_table "discoveries", :force => true do |t|
    t.integer  "task_id"
    t.integer  "action_id"
    t.string   "identifier",   :limit => nil
    t.boolean  "code_changed",                :default => false
    t.string   "priority",     :limit => nil
    t.string   "title",        :limit => nil
    t.text     "message"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "kind",         :limit => nil
    t.string   "path",         :limit => nil
    t.integer  "line"
    t.integer  "column"
    t.integer  "length"
    t.string   "branch",       :limit => nil
  end

  add_index "discoveries", ["action_id"], :name => "index_discoveries_on_action_id"
  add_index "discoveries", ["identifier"], :name => "index_discoveries_on_identifier"
  add_index "discoveries", ["task_id"], :name => "index_discoveries_on_task_id"

  create_table "docker_events", :force => true do |t|
    t.integer  "repo_id"
    t.integer  "task_id"
    t.string   "event_id",     :limit => nil
    t.string   "container_id", :limit => nil
    t.string   "status",       :limit => nil
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "docker_events", ["container_id"], :name => "index_docker_events_on_container_id"
  add_index "docker_events", ["repo_id"], :name => "index_docker_events_on_repo_id"
  add_index "docker_events", ["task_id"], :name => "index_docker_events_on_task_id"

  create_table "jobs", :force => true do |t|
    t.integer  "task_id"
    t.string   "slug",       :limit => nil
    t.string   "status",     :limit => nil
    t.text     "result"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "jobs", ["task_id"], :name => "index_jobs_on_task_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "repo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["user_id", "repo_id"], :name => "index_memberships_on_user_id_and_repo_id", :unique => true

  create_table "owners", :force => true do |t|
    t.integer "github_id"
    t.string  "name",         :limit => nil
    t.boolean "organization"
  end

  add_index "owners", ["github_id"], :name => "index_owners_on_github_id", :unique => true

  create_table "repo_behaviors", :id => false, :force => true do |t|
    t.integer "behavior_id"
    t.integer "repo_id"
  end

  add_index "repo_behaviors", ["repo_id", "behavior_id"], :name => "index_repo_behaviors_on_repo_id_and_behavior_id", :unique => true

  create_table "repos", :force => true do |t|
    t.integer  "github_id"
    t.string   "name",             :limit => nil
    t.string   "owner",            :limit => nil
    t.string   "github_full_name", :limit => nil
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.integer  "owner_id"
    t.string   "webhook_id",       :limit => nil
    t.boolean  "active",                          :default => false
    t.boolean  "private",                         :default => false
    t.string   "tags",             :limit => nil, :default => "{}"
    t.string   "default_branch",   :limit => nil
  end

  add_index "repos", ["github_full_name"], :name => "index_repos_on_github_full_name", :unique => true
  add_index "repos", ["github_id"], :name => "index_repos_on_github_id", :unique => true

  create_table "tasks", :force => true do |t|
    t.integer  "number",                          :default => 0
    t.integer  "repo_id"
    t.string   "container_id",     :limit => nil
    t.integer  "duration",                        :default => 0
    t.string   "commit",           :limit => nil
    t.string   "authors",          :limit => nil
    t.string   "status",           :limit => nil, :default => "pending"
    t.string   "kind",             :limit => nil
    t.datetime "completed_at"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.text     "logs"
    t.string   "container_status", :limit => nil
    t.integer  "trigger_id"
    t.string   "reason",           :limit => nil
    t.integer  "behavior_id"
  end

  add_index "tasks", ["container_id"], :name => "index_tasks_on_container_id"
  add_index "tasks", ["repo_id"], :name => "index_tasks_on_repo_id"

# Could not dump table "triggers" because of following StandardError
#   Unknown type 'json' for column 'payload'

  create_table "users", :force => true do |t|
    t.integer  "github_id"
    t.string   "email",                :limit => nil
    t.string   "login",                :limit => nil
    t.string   "name",                 :limit => nil
    t.string   "company",              :limit => nil
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.string   "gravatar_id",          :limit => nil
    t.string   "avatar_url",           :limit => nil
    t.string   "token",                :limit => nil
    t.boolean  "syncing",                             :default => false
    t.datetime "last_synchronized_at"
    t.boolean  "beta",                                :default => false
    t.string   "token_scopes",         :limit => nil
  end

  add_index "users", ["github_id"], :name => "index_users_on_github_id"

end
