class EndNotificationEmailSentOnSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :end_notification_email_sent, :boolean
  end

  def self.down
    remove_column :surveys, :end_notification_email_sent
  end
end