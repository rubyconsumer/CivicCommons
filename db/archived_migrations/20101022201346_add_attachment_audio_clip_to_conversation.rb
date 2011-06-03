class AddAttachmentAudioClipToConversation < ActiveRecord::Migration
  def self.up
    add_column :conversations, :audio_clip_file_name, :string
    add_column :conversations, :audio_clip_content_type, :string
    add_column :conversations, :audio_clip_file_size, :integer
    add_column :conversations, :audio_clip_updated_at, :datetime
  end

  def self.down
    remove_column :conversations, :audio_clip_file_name
    remove_column :conversations, :audio_clip_content_type
    remove_column :conversations, :audio_clip_file_size
    remove_column :conversations, :audio_clip_updated_at
  end
end
