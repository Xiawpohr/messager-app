class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_#{current_user.id}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    conversation = Conversation.find_by(id: data['conversation_id'])
    if conversation && conversation.participates?(current_user)
      message = current_user.personal_messages.build(content: data['message'])
      message.conversation = conversation
      message.save!
    end
  end
end
