class PersonalMessage < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  after_create_commit do
    conversation.touch
    NotificationBroadcastJob.perform_later(self)
  end

  def receiver
    user == conversation.author ? conversation.receiver : conversation.author
  end
end
