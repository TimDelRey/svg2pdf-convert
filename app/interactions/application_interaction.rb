class ApplicationInteraction < ActiveInteraction::Base
  def error_message
    errors.full_messages.to_sentence
  end
end
