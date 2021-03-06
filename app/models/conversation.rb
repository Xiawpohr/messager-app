class Conversation < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :personal_messages, -> { order(created_at: :asc) }, dependent: :destroy

  validates :author, uniqueness: { scope: :receiver}

  scope :participating, -> (user) do
     where('(conversations.author_id = ? OR conversations.receiver_id = ?)', user.id, user.id)
  end

  scope :between, -> (sender_id, receiver_id) do
    where(author_id: sender_id, receiver_id: receiver_id).or(where(author_id: receiver_id, receiver_id: sender_id)).limit(1)
  end

  def with(user)
    user == author ? receiver : author
  end

  def participates?(user)
    user == author || user == receiver
  end

end
