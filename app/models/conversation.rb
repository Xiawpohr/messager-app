class Conversation < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :reciever, class_name: 'User'
  has_many :personal_messages, -> { order(create_at: :asc) }, dependent: :destroy

  validates :author, uniqueness: { scope: :receiver}

end
