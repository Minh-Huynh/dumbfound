class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'faraday_middleware'

  def reply
    msg = SMSRequest.new(from: params[:From], message: params[:Body]).send_text_message
  end

end
