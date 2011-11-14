module CivicCommonsDriver
  module Database
    def database
      Database
    end

    def self.has_any?(type)
      !Topic.count.zero?
    end

    def self.has_any_topics?
      !Topic.count.zero?
    end

    def self.first_topic
      Topic.first
    end

    def self.latest_topic
      topic = Topic.last
      topic.instance_eval do
        def container
          "[data-topic-id='#{self.id}']"
        end
      end
      topic
    end

    def self.has_a_topic
      create_topic
    end

    def self.has_an_issue attributes={}
      create_issue attributes 
    end

    def self.create_topic(attributes={})
      Factory.create :topic, attributes
    end

    def self.create_issue(attributes= {})
      Factory.create :issue, attributes
    end

    def self.latest_issue
      IssuePresenter.new Issue.last
    end
    def self.issues 
      Issue.all.map! { |i| IssuePresenter.new i }
    end
    def self.topics
      Topic.all
    end

    def self.has_any_issues?
      !Issue.all.empty?
    end
  end
end
