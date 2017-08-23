class PersonalMessagesController < ApplicationController
  before_action :find_conversation

  def new
    redirect_to conversation_path(@conversation) and return if @conversation
    @message = current_user.personal_messages.build
  end

  def create
    @conversation ||=  Conversation.create(author_id: current_user.id, receiver_id: @receiver.id)
    @message = current_user.personal_messages.build(message_params)
    @message.conversation = @conversation
    @message.save!

    flash[:success] = 'you sent a message successfully!'
    redirect_to conversation_path(@conversation)
  end

  private

  def message_params
    params.require(:personal_message).permit(:content)
  end

  def find_conversation
    if params[:receiver_id]
      @receiver = User.find_by(id: params[:receiver_id])
      redirect_to(root_path) and return unless @receiver
      @conversation = Conversation.between(current_user.id, @receiver.id)[0]
    else
      @conversation = Conversation.find_by(id: params[:conversation_id])
      redirect_to(root_path) and return unless @conversation && @conversation.participates?(current_user)
    end
  end
end
