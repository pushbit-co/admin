module Pushbit
  class Repo < ActiveRecord::Base
    has_many :tasks
    has_many :triggers
    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships
    has_many :repo_behaviors, dependent: :destroy
    has_many :behaviors, through: :repo_behaviors
    belongs_to :owner

    validates :github_id, uniqueness: true, presence: true

    def self.active
      where(active: true)
    end

    def self.find_or_create_with(attributes)
      repo = find_by(github_full_name: attributes[:github_full_name]) ||
             find_by(github_id: attributes[:github_id]) ||
             Repo.new

      repo.update!(attributes)
      repo
    end

    def name
      if github_full_name
        github_full_name.split('/').last
      end
    end

    def github_owner
      if github_full_name
        github_full_name.split('/').first
      end
    end
    
    def labels
      Octokit.auto_paginate = true
      client = Octokit::Client.new(access_token: ENV.fetch("GITHUB_TOKEN"))
      client.labels(github_full_name)
    end

    def activate!(current_user)
      self.active = true
      self.behaviors = Behavior.all
      self.save!

      trigger = Trigger.create!(
        kind: 'setup',
        repo: self,
        triggered_by: current_user.github_id
      )
      trigger.execute!

      Action.create!(
        kind: 'subscribe',
        repo: self,
        user: current_user,
        github_id: github_id
      )
    end

    def deactivate!(current_user)
      update(active: false, behaviors:[])

      Action.create!(
        kind: 'unsubscribe',
        repo: self,
        user: current_user,
        github_id: github_id
      )
    end

  end
end
