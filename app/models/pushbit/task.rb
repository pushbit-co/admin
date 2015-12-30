module Pushbit
  class Task < ActiveRecord::Base
    
    default_scope -> { order('tasks.id DESC') }

    belongs_to :repo
    belongs_to :trigger
    belongs_to :behavior
    before_update :set_duration
    
    has_many :docker_events
    has_many :actions
    has_many :discoveries
    
    validates :repo, presence: true
    validates :trigger, presence: true
    validates :status, inclusion: %w(pending created running failed success)
    validates :container_status, allow_blank: true, inclusion: %w(pull create attach start stop restart pause paused unpause resize die destroy)

    def has_unactioned_discoveries
      discoveries.unactioned.length > 0
    end

    def triggered_by_login
      if trigger && trigger.triggered_by
        @user ||= User.find_by(github_id: trigger.triggered_by)
        @user ? @user.login : "unknown"
      else
        "pushbit-co"
      end    
    end

    def labels
      labels_desired = discoveries.unactioned.pluck(:kind)
      labels_available = repo.labels.map { |label| label.name }

      if behavior.negative?
        labels_desired = labels_desired + ['bug', 'problem']
      else
        labels_desired = labels_desired + ['enhancement']
      end

      output = labels_available & labels_desired
      output << "pushbit"
    end
    
    def complete!
      save!
      TaskCompletedWorker.perform_async(self.id)
    end

    def execute!(changed_files=[], head_sha=nil)
      puts "Task id: #{id} - EXECUTE (#{behavior.kind})"
      puts "Using image: #{image.id})"
      
      changed_files = changed_files.map { |f| f['filename'] } 
      
      container = Docker::Container.create({
        "Image" => image.id, 
        "Env" => [
          "GITHUB_USER=#{repo.github_owner}", 
          "GITHUB_REPO=#{repo.name}", 
          "GITHUB_TOKEN=#{ENV.fetch("GITHUB_TOKEN")}",
          "GITHUB_NUMBER=#{trigger.payload ? trigger.payload["number"] : nil}",
          "BASE_BRANCH=#{head_sha || repo.default_branch || "master"}",
          "CHANGED_FILES=#{changed_files.join(' ')}",
          "TASK_ID=#{id}",
          "ACCESS_TOKEN=#{access_token}",
          "APP_URL=#{ENV.fetch("APP_URL")}"
        ]
      })
      
      #TODO what happens to container if this fails
      self.update!(
        container_id: container.id,
        status: :created
      )
      
      container.start
    rescue Docker::Error::NotFoundError => e
      self.update!({
        status: :failed,
        reason: e.message
      })
      raise e #capture in sentry
    end

    def image
      @image ||= load_image
    end

    def logs=(value)
      # removes unsupported chars from log output (cant be saved in pg)
      write_attribute(:logs, value.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub("\u0000", ''))
    end

    def access_token
      Digest::MD5.hexdigest "#{ENV.fetch('BASIC_AUTH_SECRET')}#{id}"
    end

    def container
      return nil unless container_id
      ::Docker::Container.get(container_id)
    rescue Docker::Error::NotFoundError
      nil
    end

    private

    def set_duration
      if completed_at && duration == 0
        self.duration = completed_at.to_i - created_at.to_i
      end
    end

    def load_image
      if ENV.fetch("RACK_ENV") == "development"
        puts "in development looking for image by development tag:"
        puts "pushbit-development/#{behavior.kind}:latest"
        if Docker::Image.exist?("pushbit-development/#{behavior.kind}:latest")
          puts "development image found"
          return Docker::Image.get("pushbit-development/#{behavior.kind}:latest")
        end
        puts "development image not found"
      end
      Docker::Image.create('fromImage' => "pushbit/#{behavior.kind}") 
    end
    
  end
end
