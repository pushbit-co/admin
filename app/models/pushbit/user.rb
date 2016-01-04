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
  end
end