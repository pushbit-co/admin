module Pushbit
  class User < ActiveRecord::Base
    include ActiveModel::MassAssignmentSecurity
    include BCrypt
    
    attr_accessible :email, :login, :name
    before_create :set_beta
    after_create :create_action
    
    has_many :memberships, dependent: :destroy
    has_many :repos, through: :memberships
    
    validates :github_id, presence: true, uniqueness: true
    validates :login, presence: true, uniqueness: true
    
    def self.find_or_create_with(attributes)
      user = find_by(github_id: attributes[:github_id]) || User.new
      user.assign_attributes attributes, without_protection: true
      
      # clear existing repo memberships whenever our token scope changes
      if user.token_scopes_changed?
        user.last_synchronized_at = nil
        user.repos.clear
      end
      
      user.save!
      user
    end
    
    def active_repos
      repos.active
    end
    
    def token=(value)
      unless value == self.token
        encrypted_token = Security.encrypt(value)
        write_attribute(:token, encrypted_token)
      end
    end
    
    def token
      encrypted_token = read_attribute(:token)
      unless encrypted_token.nil?
        Security.decrypt(encrypted_token)
      end
    end

    def has_active_repos?
      active_repos.count > 0
    end

    def has_access_to_private_repos?
      if token_scopes
        token_scopes.split(",").include? "repo"
      else
        false
      end
    end
      
    def sync_repositories!
      if !syncing? && (!last_synchronized_at || last_synchronized_at < 1.minute.ago)
        self.update_attribute(:syncing, true)
        RepoSyncronizationWorker.perform_async(id)
      end
    end

    def client
      @client ||= Octokit::Client.new(:access_token => token)
    end
    
    private
    
    def create_action
      Action.create!(
        kind: 'signedup',
        user: self,
        github_id: self.github_id
      )
    end
    
    def set_beta
      if ["awsmsrc", "tommoor"].include?(login)
        self.beta = true
      end
    end
  end
end