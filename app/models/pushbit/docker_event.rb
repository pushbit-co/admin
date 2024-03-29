module Pushbit
  class DockerEvent < ActiveRecord::Base
    belongs_to :task
    belongs_to :repo
    
    validates :status, inclusion: %w(pull create attach start stop restart pause paused unpause resize die destroy)

    validates :task_id, presence: true
    validates :container_id, presence: true
  end
end